mkdir GraftM_output_1perc
/usr/bin/time --output=graftM_1perc_timed.txt -v bash MBARC_GraftM.sh "MBARC/fastq/SRR3656745.1perc.fastq.gz" "GraftM_output_1perc"
mkdir GraftM_output_10perc
/usr/bin/time --output=graftM_10perc_timed.txt -v bash MBARC_GraftM.sh "MBARC/fastq/SRR3656745.10perc.fastq.gz" "GraftM_output_10perc"
mkdir GraftM_output_timed
/usr/bin/time --output=graftM_timed.txt -v bash MBARC_GraftM.sh "MBARC/fastq/SRR3656745.fastq.gz" "GraftM_output_timed"
