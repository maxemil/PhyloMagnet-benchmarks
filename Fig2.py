import matplotlib
matplotlib.use('Agg')
import pandas as pd
import seaborn as sns
from itertools import product
from collections import defaultdict
import matplotlib.pyplot as plt
import glob
from ete3 import ncbi_taxonomy

MBARC_genera = ['Clostridium','Ruminiclostridium','Coraliomargarita',
    'Corynebacterium','Desulfosporosinus','Desulfotomaculum','Echinicola',
    'Escherichia','Fervidobacterium','Frateuria','Halovivax','Hirschia',
    'Olsenella','Pseudomonas','Salmonella','Segniliparus','Sediminispirochaeta',
    'Meiothermus','Natronobacterium','Natronococcus','Nocardiopsis',
    'Streptococcus','Terriglobus','Thermobacillus']

def get_counts_tree_taxon(df):
    taxa = set(df["Taxon"])
    samples = set(df["Tree"])
    counts = pd.DataFrame(columns=samples, index=taxa)
    counts = counts.fillna(0)
    for t,s in product(taxa, samples):
        counts[s].loc[t] = df[(df["Tree"] == s) & (df["Taxon"] == t)].shape[0]
    return counts

def parse_graftM_results(path):
    ncbi = ncbi_taxonomy.NCBITaxa()
    lineages = defaultdict(lambda: defaultdict(int))
    rank = "genus"
    for infile in glob.glob("{}/COG*/combined_count_table.txt".format(path)):
        taxids = set()
        tree = infile.split('/')[1]
        for line in open(infile):
            lineage = [l.strip() for l in line.split('\t')[2].split(';')]
            name2tax = ncbi.get_name_translator(lineage)
            taxids |= set([taxid for l in name2tax.values() for taxid in l])
        for k,v in ncbi.get_rank(taxids).items():
                if v == rank:
                    lineages[tree][ncbi.get_taxid_translator([k])[k]] += 1
    return pd.DataFrame.from_dict(lineages).fillna(0)

def parse_PhyloMagnet_results(infile):
    df = pd.read_csv(infile, sep='\t', header=None, names=['Sample', 'Tree', 'Taxon', 'value'], dtype=str)
    df = df[df['value'] == 'True']
    return get_counts_tree_taxon(df)

def divide_tp_and_fp(df, tool):
    df = df.apply(lambda x: x if x.name in MBARC_genera else (-1 * x), axis=1)
    df_tp = pd.DataFrame({'counts':df[df >= 0].sum(), 'tool':tool})
    df_fp = pd.DataFrame({'counts':df[df <= 0].sum(), 'tool':tool})
    return df_tp.append(df_fp)

def lighten_color(color, amount=0.5):
    import matplotlib.colors as mc
    import colorsys
    try:
        c = mc.cnames[color]
    except:
        c = color
    c = colorsys.rgb_to_hls(*mc.to_rgb(c))
    return colorsys.hls_to_rgb(c[0], 1 - amount * (1 - c[1]), c[2])

def get_counts_both_tools():
    graftm_1 = parse_graftM_results("GraftM_output_1perc")
    df = divide_tp_and_fp(graftm_1, 'GraftM 1%')
    graftm_10 = parse_graftM_results("GraftM_output_10perc")
    df = df.append(divide_tp_and_fp(graftm_10, 'GraftM 10%'))
    graftm = parse_graftM_results("GraftM_output")
    df = df.append(divide_tp_and_fp(graftm, 'GraftM'))

    counts_1 = parse_PhyloMagnet_results("MBARC/queries_1perc/tree_decisions.txt")
    df = df.append(divide_tp_and_fp(counts_1, 'PhyloMagnet 1%'))
    counts_10 = parse_PhyloMagnet_results("MBARC/queries_10perc/tree_decisions.txt")
    df = df.append(divide_tp_and_fp(counts_10, 'PhyloMagnet 10%'))
    counts = parse_PhyloMagnet_results("MBARC/queries/tree_decisions.txt")
    df = df.append(divide_tp_and_fp(counts, 'PhyloMagnet'))
    return df

def plot_counts_fp_tp(df):
    clr_palette = [lighten_color(sns.xkcd_rgb['scarlet'], 0.7),
                        sns.xkcd_rgb['scarlet'],
                        lighten_color(sns.xkcd_rgb['scarlet'], 1.3),
                        lighten_color(sns.xkcd_rgb['denim'], 0.7),
                        sns.xkcd_rgb['denim'],
                        lighten_color(sns.xkcd_rgb['denim'], 1.3)]

    fig, ax = plt.subplots(figsize=(10,6), tight_layout=True)
    sns.swarmplot(x=df.index, y='counts', data=df, hue='tool',
                        ax=ax, palette=clr_palette, linewidth=0.4, size=6)

    ax.set_xticklabels(labels=df.index, rotation=90)
    ax.set_ylabel('True and False positive')
    ax.set_ylim(-16, 25)
    ax.axhline(0, color=sns.xkcd_rgb['denim'])
    ax.legend(frameon=False, bbox_to_anchor=(1, 1), loc=2)
    fig.savefig('Fig2.pdf', orientation='landscape', dpi=500)

if __name__ == '__main__':
    df = get_counts_both_tools()
    plot_counts_fp_tp(df)
