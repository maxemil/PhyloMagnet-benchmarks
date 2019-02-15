Download and prepare query datasets
===============

Python script to download sra files from ENA and subsequently convert them to FASTQ files (basically taken from the template used in PhyloMagnet)
```bash
donwnload_fastq(){
  python3 <<<"""
import requests
import shutil
import subprocess

acc = '$1'
url = ''
if len(acc) == 9:
    url = 'http://ftp.sra.ebi.ac.uk/vol1/{}/{}/{}'.format(acc[0:3].lower(), acc[0:6], acc)
elif len(acc) == 10:
    url = 'http://ftp.sra.ebi.ac.uk/vol1/{}/{}/{}/{}'.format(acc[0:3].lower(), acc[0:6], "00" + acc[-1], acc)
elif len(acc) == 11:
    url = 'http://ftp.sra.ebi.ac.uk/vol1/{}/{}/{}/{}'.format(acc[0:3].lower(), acc[0:6], "0" + acc[-2:], acc)

r = requests.get(url, stream=True)
with open('$1.sra', 'wb') as f:
      shutil.copyfileobj(r.raw, f)
  """
  fastq-dump --gzip --readids --split-spot --skip-technical --clip $1.sra
}
```

MBARC-26
--------
Download MBARC-26 Illumina metagenomic dataset from ENA
```bash
mkdir MBARC/fastq
cd MBARC/fastq
donwnload_fastq SRR3656745
```

Subsample 1% and 10% from the MBARC-26 data for benchmarking
```bash
seqtk sample -s11 <(gunzip -c SRR3656745.fastq.gz) 0.01 | pigz -9 > SRR3656745.1perc.fastq.gz
seqtk sample -s11 <(gunzip -c SRR3656745.fastq.gz) 0.1 | pigz -9 > SRR3656745.10perc.fastq.gz
```

Tara Oceans
---------
Download Tara Oceans metagenomic data from ENA
```bash
mkdir Tara_Southern_Ocean/fastq
cd Tara_Southern_Ocean/fastq

for id in ERR598945 ERR599008 ERR599059 ERR599090 ERR599104 ERR599121 ERR599125 ERR599176;do
  donwnload_fastq $id
done
```

Coral Bleaching
--------------
Download Coral Bleaching metatranscriptomic data from ENA, concatenate them to a single dataset.
```bash
mkdir Tara_Southern_Ocean/fastq
cd Tara_Southern_Ocean/fastq

for id in SRR5453739 SRR5453740 SRR5453741 SRR5453742 SRR5453743 SRR5453744 SRR5453745 SRR5453746 SRR5453747 SRR5453748 SRR5453749 SRR5453750 SRR5453751 SRR5453752 SRR5453753 SRR5453754 SRR5453755 SRR5453756 SRR5453757 SRR5453758 SRR5453759 SRR5453760 SRR5453761 SRR5453762 SRR5453763 SRR5453764 SRR5453765;do
  donwnload_fastq $id
done
cat SRR*.fastq.gz > PRJNA377366.fastq.gz
```
