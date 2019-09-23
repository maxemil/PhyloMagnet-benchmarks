export NXF_LAUNCHBASE=$SNIC_TMP
export NXF_TEMP=$SNIC_TMP
export NXF_SINGULARITY_CACHEDIR=$HOME/.singularity

mkdir -p Xanthomonadales
cd Xanthomonadales
nextflow run ../PhyloMagnet/main.nf --lineage 'order' --reference_packages '../rp16_loo_rpkg/*Xanthomonadales.tgz' --fastq /proj/uppstore2017169/private/PhyloMagnet/SRR3656745.fastq.gz --megan_vmoptions ../MEGAN.vmoptions --queries_dir queries_Xanthomonadales --project snic2019-3-28 -with-singularity ../PhyloMagnet.sif -profile slurm -resume 2> Xanthomonadales.err > Xanthomonadales.log &
cd ..
sleep 2m


mkdir -p Pseudomonadaceae
cd Pseudomonadaceae
nextflow run ../PhyloMagnet/main.nf --lineage 'family' --reference_packages '../rp16_loo_rpkg/*Pseudomonadaceae.tgz' --fastq /proj/uppstore2017169/private/PhyloMagnet/SRR3656745.fastq.gz --megan_vmoptions ../MEGAN.vmoptions --queries_dir queries_Pseudomonadaceae --project snic2019-3-28 -with-singularity ../PhyloMagnet.sif -profile slurm -resume 2> Pseudomonadaceae.err > Pseudomonadaceae.log &
cd ..
sleep 2m


mkdir -p Peptococcaceae
cd Peptococcaceae
nextflow run ../PhyloMagnet/main.nf --lineage 'family' --reference_packages '../rp16_loo_rpkg/*Peptococcaceae.tgz' --fastq /proj/uppstore2017169/private/PhyloMagnet/SRR3656745.fastq.gz --megan_vmoptions ../MEGAN.vmoptions --queries_dir queries_Peptococcaceae --project snic2019-3-28 -with-singularity ../PhyloMagnet.sif -profile slurm -resume 2> Peptococcaceae.err > Peptococcaceae.log &
cd ..
sleep 2m


mkdir -p Natrialbaceae
cd Natrialbaceae
nextflow run ../PhyloMagnet/main.nf --lineage 'family' --reference_packages '../rp16_loo_rpkg/*Natrialbaceae.tgz' --fastq /proj/uppstore2017169/private/PhyloMagnet/SRR3656745.fastq.gz --megan_vmoptions ../MEGAN.vmoptions --queries_dir queries_Natrialbaceae --project snic2019-3-28 -with-singularity ../PhyloMagnet.sif -profile slurm -resume 2> Natrialbaceae.err > Natrialbaceae.log &
cd ..
sleep 2m


mkdir -p Clostridiaceae
cd Clostridiaceae
nextflow run ../PhyloMagnet/main.nf --lineage 'family' --reference_packages '../rp16_loo_rpkg/*Clostridiaceae.tgz' --fastq /proj/uppstore2017169/private/PhyloMagnet/SRR3656745.fastq.gz --megan_vmoptions ../MEGAN.vmoptions --queries_dir queries_Clostridiaceae --project snic2019-3-28 -with-singularity ../PhyloMagnet.sif -profile slurm -resume 2> Clostridiaceae.err > Clostridiaceae.log &
cd ..
sleep 2m


mkdir -p Ruminococcaceae
cd Ruminococcaceae
nextflow run ../PhyloMagnet/main.nf --lineage 'family' --reference_packages '../rp16_loo_rpkg/*Ruminococcaceae.tgz' --fastq /proj/uppstore2017169/private/PhyloMagnet/SRR3656745.fastq.gz --megan_vmoptions ../MEGAN.vmoptions --queries_dir queries_Ruminococcaceae --project snic2019-3-28 -with-singularity ../PhyloMagnet.sif -profile slurm -resume 2> Ruminococcaceae.err > Ruminococcaceae.log &
cd ..
sleep 2m


mkdir -p Acidobacteriaceae
cd Acidobacteriaceae
nextflow run ../PhyloMagnet/main.nf --lineage 'family' --reference_packages '../rp16_loo_rpkg/*Acidobacteriaceae.tgz' --fastq /proj/uppstore2017169/private/PhyloMagnet/SRR3656745.fastq.gz --megan_vmoptions ../MEGAN.vmoptions --queries_dir queries_Acidobacteriaceae --project snic2019-3-28 -with-singularity ../PhyloMagnet.sif -profile slurm -resume 2> Acidobacteriaceae.err > Acidobacteriaceae.log &
cd ..
sleep 2m


mkdir -p Lactobacillales
cd Lactobacillales
nextflow run ../PhyloMagnet/main.nf --lineage 'order' --reference_packages '../rp16_loo_rpkg/*Lactobacillales.tgz' --fastq /proj/uppstore2017169/private/PhyloMagnet/SRR3656745.fastq.gz --megan_vmoptions ../MEGAN.vmoptions --queries_dir queries_Lactobacillales --project snic2019-3-28 -with-singularity ../PhyloMagnet.sif -profile slurm -resume 2> Lactobacillales.err > Lactobacillales.log &
cd ..
sleep 2m


mkdir -p Corynebacteriales
cd Corynebacteriales
nextflow run ../PhyloMagnet/main.nf --lineage 'order' --reference_packages '../rp16_loo_rpkg/*Corynebacteriales.tgz' --fastq /proj/uppstore2017169/private/PhyloMagnet/SRR3656745.fastq.gz --megan_vmoptions ../MEGAN.vmoptions --queries_dir queries_Corynebacteriales --project snic2019-3-28 -with-singularity ../PhyloMagnet.sif -profile slurm -resume 2> Corynebacteriales.err > Corynebacteriales.log &
cd ..
sleep 2m


mkdir -p Fervidobacteriaceae
cd Fervidobacteriaceae
nextflow run ../PhyloMagnet/main.nf --lineage 'family' --reference_packages '../rp16_loo_rpkg/*Fervidobacteriaceae.tgz' --fastq /proj/uppstore2017169/private/PhyloMagnet/SRR3656745.fastq.gz --megan_vmoptions ../MEGAN.vmoptions --queries_dir queries_Fervidobacteriaceae --project snic2019-3-28 -with-singularity ../PhyloMagnet.sif -profile slurm -resume 2> Fervidobacteriaceae.err > Fervidobacteriaceae.log &
cd ..
sleep 2m


mkdir -p Spirochaetaceae
cd Spirochaetaceae
nextflow run ../PhyloMagnet/main.nf --lineage 'family' --reference_packages '../rp16_loo_rpkg/*Spirochaetaceae.tgz' --fastq /proj/uppstore2017169/private/PhyloMagnet/SRR3656745.fastq.gz --megan_vmoptions ../MEGAN.vmoptions --queries_dir queries_Spirochaetaceae --project snic2019-3-28 -with-singularity ../PhyloMagnet.sif -profile slurm -resume 2> Spirochaetaceae.err > Spirochaetaceae.log &
cd ..
sleep 2m


mkdir -p Cytophagales
cd Cytophagales
nextflow run ../PhyloMagnet/main.nf --lineage 'order' --reference_packages '../rp16_loo_rpkg/*Cytophagales.tgz' --fastq /proj/uppstore2017169/private/PhyloMagnet/SRR3656745.fastq.gz --megan_vmoptions ../MEGAN.vmoptions --queries_dir queries_Cytophagales --project snic2019-3-28 -with-singularity ../PhyloMagnet.sif -profile slurm -resume 2> Cytophagales.err > Cytophagales.log &
cd ..
sleep 2m


mkdir -p Thermaceae
cd Thermaceae
nextflow run ../PhyloMagnet/main.nf --lineage 'family' --reference_packages '../rp16_loo_rpkg/*Thermaceae.tgz' --fastq /proj/uppstore2017169/private/PhyloMagnet/SRR3656745.fastq.gz --megan_vmoptions ../MEGAN.vmoptions --queries_dir queries_Thermaceae --project snic2019-3-28 -with-singularity ../PhyloMagnet.sif -profile slurm -resume 2> Thermaceae.err > Thermaceae.log &
cd ..
sleep 2m


mkdir -p Streptococcaceae
cd Streptococcaceae
nextflow run ../PhyloMagnet/main.nf --lineage 'family' --reference_packages '../rp16_loo_rpkg/*Streptococcaceae.tgz' --fastq /proj/uppstore2017169/private/PhyloMagnet/SRR3656745.fastq.gz --megan_vmoptions ../MEGAN.vmoptions --queries_dir queries_Streptococcaceae --project snic2019-3-28 -with-singularity ../PhyloMagnet.sif -profile slurm -resume 2> Streptococcaceae.err > Streptococcaceae.log &
cd ..
sleep 2m


mkdir -p Coriobacteriales
cd Coriobacteriales
nextflow run ../PhyloMagnet/main.nf --lineage 'order' --reference_packages '../rp16_loo_rpkg/*Coriobacteriales.tgz' --fastq /proj/uppstore2017169/private/PhyloMagnet/SRR3656745.fastq.gz --megan_vmoptions ../MEGAN.vmoptions --queries_dir queries_Coriobacteriales --project snic2019-3-28 -with-singularity ../PhyloMagnet.sif -profile slurm -resume 2> Coriobacteriales.err > Coriobacteriales.log &
cd ..
sleep 2m


mkdir -p Hyphomonadaceae
cd Hyphomonadaceae
nextflow run ../PhyloMagnet/main.nf --lineage 'family' --reference_packages '../rp16_loo_rpkg/*Hyphomonadaceae.tgz' --fastq /proj/uppstore2017169/private/PhyloMagnet/SRR3656745.fastq.gz --megan_vmoptions ../MEGAN.vmoptions --queries_dir queries_Hyphomonadaceae --project snic2019-3-28 -with-singularity ../PhyloMagnet.sif -profile slurm -resume 2> Hyphomonadaceae.err > Hyphomonadaceae.log &
cd ..
sleep 2m


mkdir -p Rhodobacterales
cd Rhodobacterales
nextflow run ../PhyloMagnet/main.nf --lineage 'order' --reference_packages '../rp16_loo_rpkg/*Rhodobacterales.tgz' --fastq /proj/uppstore2017169/private/PhyloMagnet/SRR3656745.fastq.gz --megan_vmoptions ../MEGAN.vmoptions --queries_dir queries_Rhodobacterales --project snic2019-3-28 -with-singularity ../PhyloMagnet.sif -profile slurm -resume 2> Rhodobacterales.err > Rhodobacterales.log &
cd ..
sleep 2m


mkdir -p Pseudomonadales
cd Pseudomonadales
nextflow run ../PhyloMagnet/main.nf --lineage 'order' --reference_packages '../rp16_loo_rpkg/*Pseudomonadales.tgz' --fastq /proj/uppstore2017169/private/PhyloMagnet/SRR3656745.fastq.gz --megan_vmoptions ../MEGAN.vmoptions --queries_dir queries_Pseudomonadales --project snic2019-3-28 -with-singularity ../PhyloMagnet.sif -profile slurm -resume 2> Pseudomonadales.err > Pseudomonadales.log &
cd ..
sleep 2m


mkdir -p Clostridiales
cd Clostridiales
nextflow run ../PhyloMagnet/main.nf --lineage 'order' --reference_packages '../rp16_loo_rpkg/*Clostridiales.tgz' --fastq /proj/uppstore2017169/private/PhyloMagnet/SRR3656745.fastq.gz --megan_vmoptions ../MEGAN.vmoptions --queries_dir queries_Clostridiales --project snic2019-3-28 -with-singularity ../PhyloMagnet.sif -profile slurm -resume 2> Clostridiales.err > Clostridiales.log &
cd ..
sleep 2m


mkdir -p Thermotogales
cd Thermotogales
nextflow run ../PhyloMagnet/main.nf --lineage 'order' --reference_packages '../rp16_loo_rpkg/*Thermotogales.tgz' --fastq /proj/uppstore2017169/private/PhyloMagnet/SRR3656745.fastq.gz --megan_vmoptions ../MEGAN.vmoptions --queries_dir queries_Thermotogales --project snic2019-3-28 -with-singularity ../PhyloMagnet.sif -profile slurm -resume 2> Thermotogales.err > Thermotogales.log &
cd ..
sleep 2m


mkdir -p Paenibacillaceae
cd Paenibacillaceae
nextflow run ../PhyloMagnet/main.nf --lineage 'family' --reference_packages '../rp16_loo_rpkg/*Paenibacillaceae.tgz' --fastq /proj/uppstore2017169/private/PhyloMagnet/SRR3656745.fastq.gz --megan_vmoptions ../MEGAN.vmoptions --queries_dir queries_Paenibacillaceae --project snic2019-3-28 -with-singularity ../PhyloMagnet.sif -profile slurm -resume 2> Paenibacillaceae.err > Paenibacillaceae.log &
cd ..
sleep 2m


mkdir -p Enterobacterales
cd Enterobacterales
nextflow run ../PhyloMagnet/main.nf --lineage 'order' --reference_packages '../rp16_loo_rpkg/*Enterobacterales.tgz' --fastq /proj/uppstore2017169/private/PhyloMagnet/SRR3656745.fastq.gz --megan_vmoptions ../MEGAN.vmoptions --queries_dir queries_Enterobacterales --project snic2019-3-28 -with-singularity ../PhyloMagnet.sif -profile slurm -resume 2> Enterobacterales.err > Enterobacterales.log &
cd ..
sleep 2m


mkdir -p Bacillales
cd Bacillales
nextflow run ../PhyloMagnet/main.nf --lineage 'order' --reference_packages '../rp16_loo_rpkg/*Bacillales.tgz' --fastq /proj/uppstore2017169/private/PhyloMagnet/SRR3656745.fastq.gz --megan_vmoptions ../MEGAN.vmoptions --queries_dir queries_Bacillales --project snic2019-3-28 -with-singularity ../PhyloMagnet.sif -profile slurm -resume 2> Bacillales.err > Bacillales.log &
cd ..
sleep 2m


mkdir -p Enterobacteriaceae
cd Enterobacteriaceae
nextflow run ../PhyloMagnet/main.nf --lineage 'family' --reference_packages '../rp16_loo_rpkg/*Enterobacteriaceae.tgz' --fastq /proj/uppstore2017169/private/PhyloMagnet/SRR3656745.fastq.gz --megan_vmoptions ../MEGAN.vmoptions --queries_dir queries_Enterobacteriaceae --project snic2019-3-28 -with-singularity ../PhyloMagnet.sif -profile slurm -resume 2> Enterobacteriaceae.err > Enterobacteriaceae.log &
cd ..
sleep 2m


mkdir -p Atopobiaceae
cd Atopobiaceae
nextflow run ../PhyloMagnet/main.nf --lineage 'family' --reference_packages '../rp16_loo_rpkg/*Atopobiaceae.tgz' --fastq /proj/uppstore2017169/private/PhyloMagnet/SRR3656745.fastq.gz --megan_vmoptions ../MEGAN.vmoptions --queries_dir queries_Atopobiaceae --project snic2019-3-28 -with-singularity ../PhyloMagnet.sif -profile slurm -resume 2> Atopobiaceae.err > Atopobiaceae.log &
cd ..
sleep 2m


mkdir -p Spirochaetales
cd Spirochaetales
nextflow run ../PhyloMagnet/main.nf --lineage 'order' --reference_packages '../rp16_loo_rpkg/*Spirochaetales.tgz' --fastq /proj/uppstore2017169/private/PhyloMagnet/SRR3656745.fastq.gz --megan_vmoptions ../MEGAN.vmoptions --queries_dir queries_Spirochaetales --project snic2019-3-28 -with-singularity ../PhyloMagnet.sif -profile slurm -resume 2> Spirochaetales.err > Spirochaetales.log &
cd ..
sleep 2m


mkdir -p Cyclobacteriaceae
cd Cyclobacteriaceae
nextflow run ../PhyloMagnet/main.nf --lineage 'family' --reference_packages '../rp16_loo_rpkg/*Cyclobacteriaceae.tgz' --fastq /proj/uppstore2017169/private/PhyloMagnet/SRR3656745.fastq.gz --megan_vmoptions ../MEGAN.vmoptions --queries_dir queries_Cyclobacteriaceae --project snic2019-3-28 -with-singularity ../PhyloMagnet.sif -profile slurm -resume 2> Cyclobacteriaceae.err > Cyclobacteriaceae.log &
cd ..
sleep 2m
