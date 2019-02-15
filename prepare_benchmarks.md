Download published results as comparison for benchmarking
====================
MBARC-26
----------
Compare PhyloMagnet results to GraftM results, see file `MBARC/genomes_mapped.txt` for genome mapping information (i.e. abundance).

Tara Oceans
----------
```bash
cd Tara_Southern_Ocean
wget https://ndownloader.figshare.com/files/8243654 -O NON_REDUNDANT_MAGs.tar.gz
tar -xzf NON_REDUNDANT_MAGs.tar.gz
# similarly, download raw BINs

```
Compute taxonomic labels for additional genome bins using sourmash (download the database from sourmash's website https://sourmash.readthedocs.io/en/latest/databases.html)q
```bash
cd sourmash
wget https://osf.io/nemkw/download -O t-genbank-k51.lca.json.gz
nextflow run sourmash.nf --genomes ../NON_REDUNDANT_MAGs/* --reference genbank-k51.lca.json.gz --outdir signatures-MAGS -qs 35

cd ..
```
Coral Bleaching
---------------

```bash
mkdir Coral_Bleaching/transcriptome
cd Coral_Bleaching/transcriptome

split_alignment(){
  python3 <<<"""
from Bio import SeqIO
refs = [rec.id for rec in SeqIO.parse('$2$1.unique.aln', 'fasta')]
queries = [rec for rec in SeqIO.parse('$1.refquer.aln', 'fasta') if not rec.id in refs]
with open('$1.quer.aln', 'w') as out:
    for rec in queries:
        SeqIO.write(rec, out, 'fasta')
"""
}
```
Download the metatranscriptomic assembly from GEO database. prepare blast database
```bash
TRANSCRIPTOME_FILE=GSE97888%5FMetatranscriptome%5Fqualityfiltered%2Efasta%2Egz
wget https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE97888&format=file&file=$TRANSCRIPTOME_FILE -O GSE97888.fasta.gz
gunzip GSE97888.fasta.gz
makeblastdb -in GSE97888.fasta -out GSE97888.db -dbtype nucl

```
For each reference OG, identify homologous transcripts and place them onto the ref tree.
```bash
cd ..
mkdir place_transcripts
cd place_transcripts

for dir in ../references/*/;
do
  gene=${dir#../references/}
  gene=${gene%/}
  tblastn -db ../transcriptome/GSE97888.db -num_threads 30 -query $dir$gene.unique.fasta -evalue 1e-15 -outfmt '6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send sframe evalue bitscore' -out $gene.tblastn
  python3 ../get_blast_hsp.py -b $gene.tblastn -f ../transcriptome/GSE97888.fasta -o $gene.hits --translate -n qseqid sseqid pident length mismatch gapopen qstart qend sstart send sframe evalue bitscore
  python3 ../get_blast_hsp.py -b $gene.tblastn -f ../transcriptome/GSE97888.fasta -o $gene.nucl.hits -n qseqid sseqid pident length mismatch gapopen qstart qend sstart send sframe evalue bitscore
  singularity exec -B /local:/local ../../PhyloMagnet.simg trimal -in $dir$gene.unique.aln -out $gene.ref.phy -phylip
  singularity exec -B /local:/local ../../PhyloMagnet.simg papara -t $dir$gene.treefile -s $gene.ref.phy -q $gene.hits -a -n $gene -r
  singularity exec -B /local:/local ../../PhyloMagnet.simg epa-ng --split $gene.ref.phy papara_alignment.$gene
  mv query.fasta $gene.quer.aln
  singularity exec -B /local:/local ../../PhyloMagnet.simg epa-ng --ref-msa $dir$gene.unique.aln --tree $dir$gene.treefile --query $gene.quer.aln --model $dir$gene.modelfile --no-heur --threads 10
  mv epa_result.jplace $gene.jplace
  mv epa_info.log $gene.epa_info.log
  singularity exec -B /local:/local ../../PhyloMagnet.simg gappa analyze assign --jplace-path $gene.jplace --taxon-file $dir$gene.taxid.map --threads 10
  mv profile.csv $gene.csv
  rm labelled_tree
  mv per_pquery_assign $gene.assign
  singularity exec -B /local:/local ../../PhyloMagnet.simg gappa analyze graft --name-prefix 'Q_' --jplace-path $gene.jplace --threads 10
done
cd ../..
```
