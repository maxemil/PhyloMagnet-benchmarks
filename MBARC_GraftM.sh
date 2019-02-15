for gpkg in rp16_added_gpkg/*
do
  base=$(basename ${gpkg%%.gpkg})
  singularity exec -B $PWD:$PWD GraftM/graftM.img graftM graft \
                                              --forward $1 \
                                              --graftm_package $gpkg \
                                              --input_sequence_type nucleotide \
                                              --search_method hmmsearch \
                                              --assignment_method pplacer \
                                              --threads 10 \
                                              --verbosity 5 \
                                              --log $2/"$base"_GraftM.log \
                                              --output_directory $2/"$base"
done
