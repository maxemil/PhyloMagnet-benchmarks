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
-----
```{ .python include=Fig2.py}
```

Fig 3:
-----
This figure is simply the heatmap taken from the ouput of the Tara oceans benchmark, added with a 'taxonomic tree' as it can be found on ncbi. `Tara_Southern_Ocean/queries/decision_heatmap.pdf`

Fig 4:
-----
These are the two trees `Coral_Bleaching/queries/PRJNA377366/PRJNA377366-psbb.newick` and `Coral_Bleaching/place_transcripts/psbb.newick` aligned to each other so as to be able to compare the placements

Fig S1:
-----

```{ .python include=FigS1.py}
```
![Classification results of PhyloMagnet and GraftM on the full MBARC-26 dataset. Values and colors correspond to the number of rp16 trees a genus was identified in. Those genera that are part of the MBARC-26 community are written in bold.](figures/FigS1.pdf)

\newpage{}
Fig S2:
-----
```{ .python include=FigS2.py}
```
![Computational footprint of PhyloMagnet and GraftM for the complete MBARC-26 dataset (50Gb), the subsample of 1% (5Gb) and of 10% (0.5Gb). top: runtime on 10 CPUs. bottom: peak memory usage.](figures/FigS2.pdf)
