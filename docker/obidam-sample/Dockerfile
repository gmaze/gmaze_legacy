# Copyright (c) OBIDAM
# Distributed under the terms of the Modified BSD License.

# Thoe goal of this dockerfile is to create an image with all the basics
# to run a notebook with python 2.7 and pyspark

# Debian Jessie debootstrap from 2017-02-27
# https://github.com/docker-library/official-images/commit/aa5973d0c918c70c035ec0746b8acaec3a4d7777
FROM obidam/base

LABEL version="0.1"
LABEL description="Docker image for Ocean's Big Data Mining applications with sample script and data"

# Run commands as root
USER root

# Link appropriate volume for data access:
VOLUME ["/data"]

WORKDIR /home/$NB_USER/work

# Add local files as late as possible to avoid cache busting
COPY test_ISAS.ipynb $WORKDIR
RUN chown -R $NB_USER:users $WORKDIR/test_ISAS.ipynb

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_USER