Prepare initial rp16 references
-------
```bash
PhyloMagnet=/path/to/PhyloMagnet/

nextflow run $PhyloMagnet/main.nf \
            -with-singularity  $PhyloMagnet/PhyloMagnet.simg \
            --align_method 'mafft-einsi' \
            --phylo_method 'iqtree' \
            --cpus 36 \
            --megan_vmoptions "../MEGAN.vmoptions" \
            --reference_classes MBARC/eggnog_rp16.txt
            --reference_dir rp16_references

bash $PhyloMagnet/utils/make_reference_packages.sh rp16_references rp16_rpkg
```


Create HMM models for the alignments of reference sequences to search additional genomes and complement the reference OGs.
```bash
mkdir rp16_hmms

for cog in rp16_references/C*/COG*[0-9].unique.aln;
do
  hmmbuild rp16_hmms/$(basename ${cog%%.unique.aln}).hmm $cog;
done
```

Create the extended references including all genera included in the MBARC-26 dataset
-------
Download the genomes of relatives of the MBARC species, annotate each sequence with the taxid
```bash
download(){
  while read id tax;
  do
    ass=$(wget -q "https://www.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=assembly&term="$id -O - | ./xml_grep -cond Id --text_only)
    ftp=$(wget -q "https://www.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=assembly&id="$ass -O - | ./xml_grep -cond FtpPath_GenBank --text_only)
    base=$(basename $ftp)
    wget -q $ftp/$base"_protein.faa.gz" -O $id.faa.gz
    wget -q $ftp/$base"_genomic.fna.gz" -O $id.fna.gz
    zcat "$f.faa.gz" | sed 's/>/>'"$tax"'\./g' | gzip > "$f.labelled.faa.gz" ;
  done < $1

  zcat *.labelled.faa.gz | gzip > all_proteomes.faa.gz
}

cd MBARC/genomes_relatives
download taxids.txt
cd ../..
```

Use the HMM to search for sequences in the relatives' genomes and add these sequences to the reference fasta
```bash
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
```

Use PhyloMagnet to create alignments and trees for each of the extended reference set. Package the files into reference packages (rpkg).
```bash
nextflow run $PhyloMagnet/main.nf \
            -with-singularity $PhyloMagnet/PhyloMagnet.simg \
            --align_method 'mafft-einsi' \
            --phylo_method 'iqtree' \
            --cpus 36 \
            --megan_vmoptions "../MEGAN.vmoptions" \
            --local_ref "rp16_added_fasta/*_add.fasta" \
            --reference_dir rp16_added_references -resume

bash $PhyloMagnet/utils/make_reference_packages.sh rp16_added_references rp16_added_rpkg
```

Analogous to the rpkgs, create gpkgs to be used with graftM
```bash
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
```

Get and prepare Chloroplast gene references from uniprot
--------
```bash
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

mkdir chloroplast_references_uniprot
cd chloroplast_references_uniprot

for gene in "atpA" "atpB" "petB" "petD" "psaA" "psaB" "psbA" "psbB" "psbC" "psbD" "psbE" "psbI";
do
  wget "https://www.uniprot.org/uniprot/?query=gene%3A$gene+(reviewed%3Ayes+OR+dinophyceae)+(chloroplast+OR+plastid)&format=fasta" -O "$gene.fasta"
done
clean_headers
cd ..
```

Reconstruct alignmnents and trees for chloroplast genes and package them into rpkgs
```bash
nextflow run $PhyloMagnet/main.nf \
            -with-singularity /local/two/Software/PhyloMagnet/PhyloMagnet.simg \
            --cpus 40 \
            --local_ref "chloroplast_references_uniprot/*.fasta" \
            --megan_vmoptions "../MEGAN.vmoptions" \
            --phylo_method 'iqtree' \
            --align_method 'mafft-einsi' \
            --reference_dir 'chloroplast_references'

bash $PhyloMagnet/utils/make_reference_packages.sh chloroplast_references/ chloroplast_rpkgs/
```
