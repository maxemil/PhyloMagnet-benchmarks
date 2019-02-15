nextflow run maxemil/PhyloMagnet \
            --lineage "family" \
            -with-singularity  ../PhyloMagnet.simg \
            --cpus 32 \
            --fastq "fastq/*.fastq.gz" \
            --reference_packages "../rp16_rpkg/*" \
            --megan_vmoptions "../MEGAN.vmoptions"
