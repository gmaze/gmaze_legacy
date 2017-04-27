![Python Version](https://img.shields.io/badge/python-2.7-blue.svg)
![Code status](https://img.shields.io/badge/status-work%20in%20progress-red.svg)

# OBIDAM Docker image from base with samples

This is an image build on top of [the OBIDAM base image](../obidam-base) where we aim to add sample scripts and data.

## What it Gives You

* Jupyter Notebook 4.4
* Conda Python 2.7 environment (Python 2.7.12 :: Continuum Analytics, Inc.)
* pyspark, pandas, matplotlib, scipy, seaborn, scikit-learn pre-installed
* netcdf4, basemap, xarray, dask and tensorflow are pre-installed
* Spark 2.1.0 with Hadoop 2.7 for use in local mode or to connect to a cluster of Spark workers
* Mesos client 0.25 binary that can communicate with a Mesos master
* Unprivileged user `jovyan` (uid=1000, configurable, see options) in group `users` (gid=100) with ownership over `/home/jovyan` and `/opt/conda`
* Sample scripts and link to data

## Build the image
	docker build -t obidam/sample .

## Run it:
	docker run -it --rm -p 8888:8888 obidam/sample

## More info from the image environment:
	docker run -it --rm obidam/sample start.sh "conda list"
	docker run -it --rm obidam/sample start.sh "cat /etc/*release"
	docker run -it --rm obidam/sample start.sh "python --version"
