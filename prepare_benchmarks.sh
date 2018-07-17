download(){
  while read id;
  do
    ass=$(wget -q "https://www.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=assembly&term="$id -O - | ./xml_grep -cond Id --text_only)
    ftp=$(wget -q "https://www.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=assembly&id="$ass -O - | ./xml_grep -cond FtpPath_GenBank --text_only)
    base=$(basename $ftp)
    wget -q $ftp/$base"_protein.faa.gz" -O $id.faa.gz
    wget -q $ftp/$base"_genomic.fna.gz" -O $id.fna.gz
  done < $1

  while read f i;
  do
    zcat $f | sed 's/>/>'"$i"'\./g' | gzip > ${f%%.faa.gz}.labelled.faa.gz ;
  done < $2
  zcat *.labelled.faa.gz | gzip > all_proteomes.faa.gz
}

###################
#Prepare new references with relatives' sequences
###################
cd MBARC/genomes_relatives
download accessions.txt taxids.txt
cd ../..

nextflow run /local/two/Software/PhyloMagnet/main.nf \
            -with-singularity  /local/two/Software/PhyloMagnet/PhyloMagnet.simg \
            --align_method 'mafft-einsi' \
            --phylo_method 'iqtree' \
            --cpus 36 \
            --megan_vmoptions "../MEGAN.vmoptions" \
            --reference_classes MBARC/eggnog_rp16.txt
            --reference_dir rp16_references

mkdir rp16_hmms

for cog in rp16_references/C*/COG*[0-9].unique.aln;
do
  hmmbuild rp16_hmms/$(basename ${cog%%.unique.aln}).hmm $cog;
done

mkdir rp16_added_fasta

for hmm in rp16_hmms/COG*[0-9].hmm;
do
  hmmsearch -T 50 --tblout rp16_added_fasta/$(basename ${hmm%%.hmm}).out $hmm MBARC/genomes_relatives/all_proteomes.faa.gz;
  grep -v "^#" rp16_added_fasta/$(basename ${hmm%%.hmm}).out | awk '{print $1}' | esl-sfetch -f MBARC/genomes_relatives/all_proteomes.faa.gz - > rp16_added_fasta/$(basename ${hmm%%.hmm}).hits.fasta ;
done

for cog in  rp16_references/C*/COG*[0-9].fasta;
do
  cat $cog rp16_added_fasta/$(basename ${cog%%.fasta}).hits.fasta > rp16_added_fasta/$(basename ${cog%%.fasta})_add.fasta
done

nextflow run /local/two/Software/PhyloMagnet/main.nf \
            -with-singularity  /local/two/Software/PhyloMagnet/PhyloMagnet.simg \
            --align_method 'mafft-einsi' \
            --phylo_method 'iqtree' \
            --cpus 36 \
            --megan_vmoptions "../MEGAN.vmoptions" \
            --local_ref "rp16_added_fasta/*_add.fasta" \
            --reference_dir rp16_added_references -resume

bash /local/two/Software/PhyloMagnet/utils/make_reference_packages.sh rp16_added_references rp16_rpkg

mkdir rp16_added_gpkg

for cog in rp16_added_references/COG*;
do
  base=$(basename $cog)
  singularity exec -B $PWD:$PWD GraftM/graftM.img graftM create \
            --sequences $cog/$base.unique.fasta \
            --alignment $cog/$base.unique.aln \
            --rerooted_tree $cog/$base.treefile \
            --taxonomy $cog/$base.taxid.map \
            --output rp16_added_gpkg/$base.gpkg
done

####################
# get full length sequences from genomes
####################
cd MBARC/genomes
download accessions.txt taxids.txt
cd ../..

mkdir MBARC/genomes_rp16_genes

for hmm in rp16_hmms/COG*[0-9].hmm;
do
  hmmsearch -T 35 --tblout MBARC/genomes_rp16_genes/$(basename ${hmm%%.hmm}).out $hmm MBARC/genomes/all_proteomes.faa.gz;
  grep -v "^#" MBARC/genomes_rp16_genes/$(basename ${hmm%%.hmm}).out | awk '{print $1}' | esl-sfetch -f MBARC/genomes/all_proteomes.faa.gz - > MBARC/genomes_rp16_genes/$(basename ${hmm%%.hmm}).hits.fasta ;
done




singularity exec -B $PWD:$PWD GraftM/graftM.img graftM graft \
                                            --forward MBARC/fastq/SRR3656745.fastq.gz \
                                            --graftm_package rp16_added_gpkg/COG0051_add.gpkg \
                                            --input_sequence_type nucleotide \
                                            --search_method diamond \
                                            --assignment_method pplacer \
                                            --threads 20 \
                                            --verbosity 5 \
                                            --log SRR3656745-COG0051_add.log
