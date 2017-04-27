# Copyright (c) OBIDAM
# Distributed under the terms of the Modified BSD License.

FROM jupyter/pyspark-notebook

MAINTAINER OBIDAM Project <guillaume.maze@ifremer.fr>

USER root

# Install Netcdf
RUN conda install -n python2 --quiet --yes \
    'netcdf4=1.2.4' \
    && conda clean -tipsy

RUN /bin/bash -c 'source activate python2;conda list;python --version'

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_USER
