nextflow run maxemil/PhyloMagnet \
            --lineage "family","Dinophyceae" \
            -with-singularity  ../PhyloMagnet.simg \
            --cpus 40 \
            --reference_packages "../chloroplast_rpkgs/*" \
            --megan_vmoptions "../MEGAN.vmoptions" \
            --fastq "fastq/PRJNA377366.fastq.gz" \
            -with-report "Coral_Bleaching.html"
