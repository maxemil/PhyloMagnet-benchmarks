nextflow run /local/two/Software/PhyloMagnet/main.nf \
            --lineage "Clostridium","Ruminiclostridium","Coraliomargarita","Corynebacterium","Desulfosporosinus","Desulfotomaculum","Echinicola","Escherichia","Fervidobacterium","Frateuria","Halovivax","Hirschia","Meiothermus","Natronobacterium","Natronococcus","Nocardiopsis","Olsenella","Pseudomonas","Salmonella","Segniliparus","Sediminispirochaeta","Streptococcus","Terriglobus","Thermobacillus","Enterobacteriaceae" \
            -with-singularity  /local/two/Software/PhyloMagnet/PhyloMagnet.simg \
            -resume \
            --cpus 40 \
            --reference_packages "../rp16_added_rpkg/*.tgz*" \
            --fastq "fastq/*" \
            --megan_vmoptions "../MEGAN.vmoptions"
