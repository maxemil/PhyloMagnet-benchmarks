To execute the different parts of the benchmarks (most results file are included in this repository), use these commands:

```
sudo singularity build benchmark.simg Singularity
cd GraftM
sudo singularity build graftm.simg Singularity.graftM
cd ..

sed -n '/^```/,/^```/ p' < prepare_queries.md | sed '/^```/ d' > prepare_queries.sh
singularity exec -B $PWD:$PWD benchmark.simg prepare_queries.sh
sed -n '/^```/,/^```/ p' < prepare_references.md | sed '/^```/ d' > prepare_references.sh
singularity exec -B $PWD:$PWD benchmark.simg prepare_references.sh
sed -n '/^```/,/^```/ p' < prepare_benchmarks.md | sed '/^```/ d' > prepare_benchmarks.sh
singularity exec -B $PWD:$PWD benchmark.simg prepare_benchmarks.sh

./MBARC/MBARC.sh
./MBARC_GraftM_time.sh
./Coral_Bleaching/Coral_Bleaching.sh
./Tara_Southern_Ocean/Tara_SOC.sh

python3 Fig2.py
python3 FigS1.py
python3 FigS2.py
```

If you want to create a PDF with all the commands and comments:
```
pandoc prepare_references.md \
        prepare_queries.md \
        prepare_benchmarks.md \
        benchmarks.md \
        bibliography.md \
        --listings -H pandoc-listings-setup.tex \
        --filter pandoc-include-code \
        -o supplement.pdf
```
