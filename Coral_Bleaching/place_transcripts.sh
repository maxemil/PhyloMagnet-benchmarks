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
mkdir transcriptome
cd transcriptome
wget https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE97888&format=file&file=GSE97888%5FMetatranscriptome%5Fqualityfiltered%2Efasta%2Egz
gunzip GSE97888_Metatranscriptome_qualityfiltered.fasta.gz
cd ..
makeblastdb -in transcriptome/GSE97888_Metatranscriptome_qualityfiltered.fasta -out transcriptome/GSE97888_Metatranscriptome_qualityfiltered.db -dbtype nucl
mkdir place_transcripts
cd place_transcripts

for dir in ../references/*/;
do
  gene=${dir#../references/}
  gene=${gene%/}
  tblastn -db ../transcriptome/GSE97888_Metatranscriptome_qualityfiltered.db -num_threads 30 -query $dir$gene.unique.fasta -evalue 1e-15 -outfmt '6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send sframe evalue bitscore' -out $gene.tblastn
  python3 ../../scripts/get_blast_hsp.py -b $gene.tblastn -f ../transcriptome/GSE97888_Metatranscriptome_qualityfiltered.fasta -o $gene.hits --translate -n qseqid sseqid pident length mismatch gapopen qstart qend sstart send sframe evalue bitscore
  python3 ../../scripts/get_blast_hsp.py -b $gene.tblastn -f ../transcriptome/GSE97888_Metatranscriptome_qualityfiltered.fasta -o $gene.nucl.hits -n qseqid sseqid pident length mismatch gapopen qstart qend sstart send sframe evalue bitscore
  trimal -in $dir$gene.unique.aln -out $gene.ref.phy -phylip
  singularity exec -B /local:/local /local/two/Software/PhyloMagnet/PhyloMagnet.simg papara -t $dir$gene.treefile -s $gene.ref.phy -q $gene.hits -a -n $gene -r
  trimal -in papara_alignment.$gene -out $gene.refquer.aln -fasta
  split_alignment $gene $dir
  singularity exec -B /local:/local /local/two/Software/PhyloMagnet/PhyloMagnet.simg epa-ng --ref-msa $dir$gene.unique.aln --tree $dir$gene.treefile --query $gene.quer.aln --model $dir$gene.modelfile --no-heur --threads 10
  mv epa_result.jplace $gene.jplace
  mv epa_info.log $gene.epa_info.log
  singularity exec -B /local:/local /local/two/Software/PhyloMagnet/PhyloMagnet.simg gappa analyze assign --jplace-path $gene.jplace --taxon-file $dir$gene.taxid.map --threads 10
  mv profile.csv $gene.csv
  rm labelled_tree
  mv per_pquery_assign $gene.assign
  singularity exec -B /local:/local /local/two/Software/PhyloMagnet/PhyloMagnet.simg gappa analyze graft --name-prefix 'Q_' --jplace-path $gene.jplace --threads 10
done
