params.genomes = ""
params.outdir = ""
params.reference = ""

genomes = Channel.fromPath(params.genomes)
reference = Channel.fromPath(params.reference)

process computeSignature {
  input:
  file genome from genomes

  output:
  file "${genome}.sig" into signatures

  publishDir "${params.outdir}/signatures", mode: 'copy'

  script:
  """
  sourmash compute --scaled=1000 $genome
  """
}


process classifySignatures {
  input:
  file "*" from signatures.collect()
  file reference from reference

  output:
  file "classification.csv" into results

  publishDir params.outdir, mode: 'copy'

  script:
  """
  sourmash lca classify --db $reference --query *.sig > classification.csv
  """
}
