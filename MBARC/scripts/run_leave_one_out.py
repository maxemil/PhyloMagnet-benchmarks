import glob
import shutil
import os
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
    # 'Nocardiopsaceae':'Streptosporangiales',
    # 'Nocardiopsis':'Nocardiopsaceae',

def run_PhyloMagnet(taxon):
    cmd = """
mkdir -p {}
cd {}
nextflow run ../PhyloMagnet/main.nf \
--lineage 'family' \
--reference_packages '../rp16_loo_rpkg/*{}.tgz' \
--fastq /proj/uppstore2017169/private/PhyloMagnet/SRR3656745.fastq.gz \
--megan_vmoptions ../MEGAN.vmoptions \
--queries_dir queries_{} \
--project snic2019-3-28 \
-with-singularity ../PhyloMagnet.sif \
-profile slurm \
-resume 2> {}.err > {}.log &
cd ..
sleep 2m
    """.format(taxon, taxon, taxon, taxon, taxon, taxon, taxon, taxon)
    print(cmd)


for taxon in set(MBARC_taxa.values()):
    if glob.glob("rp16_loo_rpkg/*{}.tgz".format(taxon)):
        run_PhyloMagnet(taxon)
