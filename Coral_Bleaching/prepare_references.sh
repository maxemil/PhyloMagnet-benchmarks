clean_headers(){
  python3 <<<"""
from Bio import SeqIO
import re

re.compile('OX=[0-9]*')
pattern = re.compile('OX=[0-9]*')

for gene in ['atpA', 'atpB', 'petB', 'petD', 'psaA', 'psaB', 'psbA', 'psbB', 'psbC', 'psbD', 'psbE', 'psbI']:
    recs = []
    for rec in SeqIO.parse('{}.fasta'.format(gene),'fasta'):
        seqid = rec.id.split('|')[1]
        seqtax = pattern.search(rec.description).group(0).split('=')[1]
        rec.id = '{}.{}'.format(seqtax, seqid)
        rec.description = ''
        recs.append(rec)
    with open('{}.fasta'.format(gene), 'w') as outhandle:
        SeqIO.write(recs, outhandle, 'fasta')
  """
}

###################
#Prepare new references with relatives' sequences
###################
mkdir references_uniprot
cd references_uniprot

for gene in "atpA" "atpB" "petB" "petD" "psaA" "psaB" "psbA" "psbB" "psbC" "psbD" "psbE" "psbI";
do
  wget "https://www.uniprot.org/uniprot/?query=gene%3A$gene+(reviewed%3Ayes+OR+dinophyceae)+(chloroplast+OR+plastid)&format=fasta" -O "$gene.fasta"
done

clean_headers

cd ..

nextflow run /local/two/Software/PhyloMagnet/main.nf \
            -with-singularity /local/two/Software/PhyloMagnet/PhyloMagnet.simg \
            --cpus 40 \
            --local_ref "references_uniprot/*.fasta" \
            --megan_vmoptions "../MEGAN.vmoptions" \
            --phylo_method 'iqtree' \
            --align_method 'mafft-einsi'

bash ~software/PhyloMagnet/utils/make_reference_packages.sh references/ rpkgs/
