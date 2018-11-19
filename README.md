sed -n '/^```/,/^```/ p' < prepare_queries.md | sed '/^```/ d' > prepare_queries.sh 
