sed -n '/^```/,/^```/ p' < prepare_queries.md | sed '/^```/ d' > prepare_queries.sh
sed -n '/^```/,/^```/ p' < prepare_references.md | sed '/^```/ d' > prepare_references.sh

pandoc prepare_references.md \
        prepare_queries.md \
        prepare_benchmarks.md \
        bibliography.md \
        --listings -H pandoc-listings-setup.tex \
        -o supplement.pdf
