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

cd genomes
download accessions.txt taxids.txt
cd ..


###################
#Prepare new references with relatives' sequences
###################

python /local/two/Software/eggnog-mapper/emapper.py --cpu 10 -d NOG -o NC_027093.1 --output_dir genomes -i genomes/NC_027093.1.faa.gz
python /local/two/Software/eggnog-mapper/emapper.py --cpu 10 -d NOG -o NC_014287.1 --output_dir genomes -i genomes/NC_014287.1.faa.gz
python /local/two/Software/eggnog-mapper/emapper.py --cpu 10 -d NOG -o NC_014267.1 --output_dir genomes -i genomes/NC_014267.1.faa.gz

comm -1 -2 <(sort genomes/NC_027093.1.emapper.NOGs) <(sort genomes/NC_014287.1.emapper.NOGs) | comm -1 -2 - <(sort genomes/NC_014267.1.emapper.NOGs) | sed '/^COG/! s/^/ENOG41/g' > eggnog.txt

cd genomes
while read f i;
do
  sed -i 's/^/'"$i"'\./g' ${f%%.faa.gz}.emapper.annotations
done < taxids.txt

nextflow run /local/two/Software/PhyloMagnet/main.nf \
            -with-singularity  /local/two/Software/PhyloMagnet/PhyloMagnet.simg \
            -resume \
            --align_method 'mafft-fftnsi' \
            --phylo_method 'iqtree -fast' \
            --cpus 40 \
            --reference_classes "eggnog.txt" \
            --megan_vmoptions "../MEGAN.vmoptions"

mkdir ref_add_fasta

for f in $(ls -d references/*/);
do
  cog=$(basename $f);
  cog_safe=${cog#ENOG41}
  cat genomes/*.annotations | grep "$cog_safe|" | cut -f1 > ref_add_fasta/$cog.hits;
  cp $f/$cog.fasta ref_add_fasta/"$cog"_add.fasta
  seqtk subseq genomes/all_proteomes.faa.gz ref_add_fasta/$cog.hits >> ref_add_fasta/"$cog"_add.fasta
done

nextflow run /local/two/Software/PhyloMagnet/main.nf \
            -with-singularity  /local/two/Software/PhyloMagnet/PhyloMagnet.simg \
            -resume \
            --reference_dir "references_add" \
            --align_method 'mafft-einsi' \
            --phylo_method 'iqtree' \
            --cpus 40 \
            --local_ref "local_refs/*" \
            --megan_vmoptions "../MEGAN.vmoptions"


bash /local/two/Software/PhyloMagnet/utils/make_reference_packages.sh references_add ref_add_rpkg
