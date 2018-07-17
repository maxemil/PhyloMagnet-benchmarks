nextflow run /local/two/Software/PhyloMagnet/main.nf \
            --lineage "family","Dinophyceae" \
            -with-singularity  /local/two/Software/PhyloMagnet/PhyloMagnet.simg \
            -resume \
            --cpus 40 \
            --reference_packages "ref_add_rpkg/*" \
            --megan_vmoptions "../MEGAN.vmoptions"
            --fastq "fastq/PRJNA*" \
