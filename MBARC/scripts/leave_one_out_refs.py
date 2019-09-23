from Bio import SeqIO
from ete3 import Tree
import glob
import os
import shutil
from collections import defaultdict
import subprocess

MBARC_taxa = {'Clostridium':'Clostridiaceae',
    'Ruminiclostridium':'Ruminococcaceae',
    'Coraliomargarita':'Puniceicoccaceae',
    'Corynebacterium':'Corynebacteriaceae',
    'Desulfosporosinus':'Peptococcaceae',
    'Desulfotomaculum':'Peptococcaceae',
    'Echinicola':'Cyclobacteriaceae',
    'Escherichia':'Enterobacteriaceae',
    'Fervidobacterium':'Fervidobacteriaceae',
    'Frateuria':'Rhodanobacteraceae',
    'Halovivax':'Natrialbaceae',
    'Hirschia':'Hyphomonadaceae',
    'Olsenella':'Atopobiaceae',
    'Pseudomonas':'Pseudomonadaceae',
    'Salmonella':'Enterobacteriaceae',
    'Segniliparus':'Segniliparaceae',
    'Sediminispirochaeta':'Spirochaetaceae',
    'Meiothermus':'Thermaceae',
    'Natronobacterium':'Natrialbaceae',
    'Natronococcus':'Natrialbaceae',
    'Streptococcus':'Streptococcaceae',
    'Terriglobus':'Acidobacteriaceae',
    'Thermobacillus':'Paenibacillaceae',
    'Acidobacteriaceae':'Acidobacteriales',
    'Atopobiaceae':'Coriobacteriales',
    'Clostridiaceae':'Clostridiales',
    'Corynebacteriaceae':'Corynebacteriales',
    'Cyclobacteriaceae':'Cytophagales',
    'Enterobacteriaceae':'Enterobacterales',
    'Fervidobacteriaceae':'Thermotogales',
    'Hyphomonadaceae':'Rhodobacterales',
    'Natrialbaceae':'Natrialbales',
    'Paenibacillaceae':'Bacillales',
    'Peptococcaceae':'Clostridiales',
    'Pseudomonadaceae':'Pseudomonadales',
    'Puniceicoccaceae':'Puniceicoccales',
    'Rhodanobacteraceae':'Xanthomonadales',
    'Ruminococcaceae':'Clostridiales',
    'Segniliparaceae':'Corynebacteriales',
    'Spirochaetaceae':'Spirochaetales',
    'Streptococcaceae':'Lactobacillales',
    'Thermaceae':'Thermales'}

MBARC_loo = defaultdict(list)
for k, v in MBARC_taxa.items():
    MBARC_loo[v].append(k)

ref_dir = "../rp16_loo_references"

def check_loo_possible(base, taxa, parent):
    parent_represented = False
    sequences_removed = False
    for line in open("{}/{}/{}.taxid.map".format(ref_dir, base, base)):
        if any("{};".format(t) in line for t in taxa) or any("{}\n".format(t) in line for t in taxa):
            sequences_removed = True
        elif "{};".format(parent) in line or "{}\n".format(parent) in line:
            parent_represented = True
    return parent_represented and sequences_removed


def get_seqnames_prune_map(base, taxa, target_base):
    seqnames  = []
    with open("{}/{}/{}.taxid.map".format(ref_dir, target_base, target_base), 'w') as out:
        for line in open("{}/{}/{}.taxid.map".format(ref_dir, base, base)):
            if any("{};".format(t) in line for t in taxa) or any("{}\n".format(t) in line for t in taxa):
                seqnames.append(line.split('\t')[0])
            else:
                print(line, file=out, end='')
    return seqnames


def prune_eggno_map(base, seqnames, target_base):
    with open("{}/{}/{}.class".format(ref_dir, target_base, target_base), 'w') as out:
        for line in open("{}/{}/{}.class".format(ref_dir, base, base)):
            print(line.replace(base, target_base), file=out, end='')
    with open("{}/{}/{}.eggnog.map".format(ref_dir, target_base, target_base), 'w') as out:
        for line in open("{}/{}/{}.eggnog.map".format(ref_dir, base, base)):
            if not line.split('\t')[0] in seqnames:
                print(line, file=out, end='')


def prune_fasta(base, seqnames, target_base, extension):
    with open("{}/{}/{}.{}".format(ref_dir, target_base, target_base, extension), 'w') as out:
        for rec in SeqIO.parse("{}/{}/{}.{}".format(ref_dir, base, base, extension), 'fasta'):
            if not rec.id in seqnames:
                SeqIO.write(rec, out, 'fasta')


def fix_alignment_all_gaps(target_base):
    cmd = "singularity exec -B $PWD PhyloMagnet.sif trimal -in {} -out {} -gt 0.0 -fasta".format(
    "{}/{}/{}.unique.aln".format(ref_dir, target_base, target_base),
    "{}/{}/{}.unique.aln".format(ref_dir, target_base, target_base))
    subprocess.call(cmd.split())


def prune_tree(base, seqnames, target_base):
    tree = Tree("{}/{}/{}.treefile".format(ref_dir, base, base), format=0)
    keep_leaves = [l.name for l in tree.iter_leaves()]
    for l in tree.iter_leaves():
        if l.name in seqnames:
            keep_leaves.remove(l.name)
    tree.prune(keep_leaves, preserve_branch_length=True)
    tree.write(outfile="{}/{}/{}.treefile".format(ref_dir, target_base, target_base), format=5)


for ref in glob.glob("{}/*_add".format(ref_dir)):
    base = os.path.basename(ref)
    for parent, taxa in MBARC_loo.items():
        if check_loo_possible(base, taxa, parent):
            target_base = base.replace('add', '{}'.format(parent))
            os.mkdir("{}/{}".format(ref_dir, target_base))

            seqnames = get_seqnames_prune_map(base, taxa, target_base)
            prune_eggno_map(base, seqnames, target_base)
            for extension in ['fasta', 'unique.aln', 'unique.fasta']:
                prune_fasta(base, seqnames, target_base, extension)
            fix_alignment_all_gaps(target_base)
            prune_tree(base, seqnames, target_base)
            shutil.copyfile("{}/{}/{}.modelfile".format(ref_dir, base, base),
                            "{}/{}/{}.modelfile".format(ref_dir, target_base, target_base))
