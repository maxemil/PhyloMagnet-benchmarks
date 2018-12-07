import matplotlib
matplotlib.use('Agg')
import pandas as pd
import seaborn as sns
from itertools import product
from collections import defaultdict
import matplotlib.pyplot as plt
import glob
from ete3 import ncbi_taxonomy

def get_counts_sample_taxon(df):
    taxa = set(df["Taxon"])
    samples = set(df["Sample"])
    counts = pd.DataFrame(columns=samples, index=taxa)
    counts = counts.fillna(0)
    for t,s in product(taxa, samples):
        counts[s].loc[t] = df[(df["Sample"] == s) & (df["Taxon"] == t)].shape[0]
    return counts

def parse_graftM_results_sample(path):
    ncbi = ncbi_taxonomy.NCBITaxa()
    lineages = defaultdict(int)
    rank = "genus"
    for infile in glob.glob("{}/COG*/combined_count_table.txt".format(path)):
        taxids = set()
        for line in open(infile):
            lineage = [l.strip() for l in line.split('\t')[2].split(';')]
            name2tax = ncbi.get_name_translator(lineage)
            taxids |= set([taxid for l in name2tax.values() for taxid in l])
        for k,v in ncbi.get_rank(taxids).items():
                if v == rank:
                    lineages[ncbi.get_taxid_translator([k])[k]] += 1
    return pd.DataFrame.from_dict(lineages,orient='index')

def parse_PhyloMagnet_results_sample(infile):
    df = pd.read_csv(infile, sep='\t', header=None, names=['Sample', 'Tree', 'Taxon', 'value'], dtype=str)
    df = df[df['value'] == 'True']
    return get_counts_sample_taxon(df)

def get_counts_both_tools_sample():
    phylomagnet = parse_PhyloMagnet_results_sample("MBARC/queries/tree_decisions.txt")
    graftm = parse_graftM_results_sample("GraftM_output")
    return (phylomagnet, graftm)

def plot_heatmap(phylomagnet, graftm):
    fig, ax = plt.subplots(figsize=(10,20), tight_layout=True)
    compare = pd.DataFrame({'GraftM':graftm[0],'PhyloMagnet':phylomagnet.SRR3656745})
    compare = compare.fillna(0)
    compare = compare.sort_values(by=['PhyloMagnet', 'GraftM'],ascending=False)
    sns.heatmap(compare, annot=True, cmap='Reds', xticklabels=True, ax=ax)
    fig.savefig('FigS1.pdf')

if __name__ == '__main__':
    phylomagnet, graftm = get_counts_both_tools_sample()
    plot_heatmap(phylomagnet, graftm)
