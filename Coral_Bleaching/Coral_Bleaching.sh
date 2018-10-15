nextflow run /local/two/Software/PhyloMagnet/main.nf \
            --lineage "family","Dinophyceae" \
            -with-singularity  /local/two/Software/PhyloMagnet/PhyloMagnet.simg \
            --cpus 44 \
            --reference_packages "rpkgs/*" \
            --megan_vmoptions "../MEGAN.vmoptions" \
            --fastq "fastq/PRJNA*" \
            -with-report "Coral_Bleaching.html"
