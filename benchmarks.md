Run Benchmarks
===========
MBARC-26 benchmark
----------
Run and time PhyloMagnet on MBARC data (full, 10% and 1% subsampled)
```{include=MBARC/MBARC.sh}
```

Run and time GraftM on MBARC data (full, 10% and 1% subsampled)
```{include=MBARC_GraftM_time.sh}
```
Where `MBARC_GraftM.sh` look like this:
```{include=MBARC_GraftM.sh}
```

Tara Southern Oceans Benchmark
-----------------
Run PhyloMagnet on the Coral Bleaching metatranscriptomic dataset
```{include=Tara_Southern_Ocean/Tara_SOC.sh}
```

Coral Bleaching Benchmark
-------------------
Run PhyloMagnet on the Tara Oceans metagenomic dataset
```{include=Coral_Bleaching/Coral_Bleaching.sh}
```

Evaluate Benchmarks
================
Fig 2:
```{include=Fig2.py}
```

Fig S1:
```{include=FigS1.py}
```

Fig S2:
```{include=FigS2.py}
```
