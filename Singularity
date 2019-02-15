From:continuumio/miniconda3:4.5.12
Bootstrap:docker

%labels
    MAINTAINER Max Emil Schön <max-emil.schon@icm.uu.se>
    DESCRIPTION Singularity image containing all requirements for running the benchmarks from the PhyloMagnet pipeline
    VERSION 0.0

%environment
    PATH=/opt/conda/envs/benchmarks/bin:$PATH
    export PATH

%files
    environment.yml /

%post
    apt-get update
    apt-get install -y procps libxtst6 pigz wget
    apt-get clean -y

    /opt/conda/bin/conda env create -f /environment.yml
    /opt/conda/bin/conda clean -a
