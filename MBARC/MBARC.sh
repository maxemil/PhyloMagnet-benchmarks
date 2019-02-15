/usr/bin/time --output=queries_1perc_timed.txt -v nextflow run maxemil/PhyloMagnet \
            --lineage "genus" \
            -with-singularity  ../PhyloMagnet.simg \
            --cpus 10 \
            --reference_packages "../rp16_added_rpkg/*.tgz*" \
            --fastq "fastq/SRR3656745.1perc.fastq.gz" \
            --megan_vmoptions "../MEGAN.vmoptions" \
            -with-report MBARC_report_1perc.html \
            --queries_dir queries_1perc

/usr/bin/time --output=queries_10perc_timed.txt -v nextflow run maxemil/PhyloMagnet \
            --lineage "genus" \
            -with-singularity  ../PhyloMagnet.simg \
            --cpus 10 \
            --reference_packages "../rp16_added_rpkg/*.tgz*" \
            --fastq "fastq/SRR3656745.10perc.fastq.gz" \
            --megan_vmoptions "../MEGAN.vmoptions" \
            -with-report MBARC_report_10perc.html \
            --queries_dir queries_10perc

/usr/bin/time --output=queries_timed.txt -v nextflow run maxemil/PhyloMagnet \
            --lineage "genus" \
            -with-singularity  ../PhyloMagnet.simg \
            --cpus 10 \
            --reference_packages "../rp16_added_rpkg/*.tgz*" \
            --fastq "fastq/SRR3656745.fastq.gz" \
            --megan_vmoptions "../MEGAN.vmoptions" \
            -with-report MBARC_report.html \
            --queries_dir queries


# --lineage "Clostridium","Ruminiclostridium","Coraliomargarita",\
#           "Corynebacterium","Desulfosporosinus","Desulfotomaculum",\
#           "Echinicola","Escherichia","Fervidobacterium","Frateuria",\
#           "Halovivax","Hirschia","Meiothermus","Natronobacterium",\
#           "Natronococcus","Nocardiopsis","Olsenella","Pseudomonas",\
#           "Salmonella","Segniliparus","Sediminispirochaeta","Streptococcus",\
#           "Terriglobus","Thermobacillus","Enterobacteriaceae" \
