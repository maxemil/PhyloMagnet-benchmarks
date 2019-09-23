cd kraken
sudo singularity build kraken.sif Singularity

singularity exec -B $PWD kraken.sif kraken2-build --standard --protein --db standard --threads 10

/usr/bin/time --output=kraken_standard_time.txt -v singularity exec \
      -B $PWD kraken.sif kraken2 --db standard --gzip-compressed \
      --use-names ../MBARC/fastq/SRR3656745.fastq.gz --threads 10 \
      --output SRR3656745.out --report SRR3656745.report
cd ..
