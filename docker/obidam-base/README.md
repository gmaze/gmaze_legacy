# OBIDAM Docker base image

This is a base image build on top of (pyspark Jupyter notebook dockerfile)[https://github.com/jupyter/docker-stacks/tree/master/pyspark-notebook] where:
* the Python 3* environment is removed and work only with Python 2.7
* Python packages useful for OBIDAM applications are added:
	* netcdf4=1.2.4
	* basemap=1.0.8
	* ecmwf_grib=1.19.0
	* pydap=3.2.0
	* xarray=0.9.1
	* dask=0.14.1
	* tensorflow=0.12.1

## What it Gives You

* Jupyter Notebook 4.4
* Conda Python 2.7 environment
* pyspark, pandas, matplotlib, scipy, seaborn, scikit-learn pre-installed
* netcdf4, basemap, xarray, dask and tensorflow are pre-installed
* Spark 2.1.0 with Hadoop 2.7 for use in local mode or to connect to a cluster of Spark workers
* Mesos client 0.25 binary that can communicate with a Mesos master
* Unprivileged user `jovyan` (uid=1000, configurable, see options) in group `users` (gid=100) with ownership over `/home/jovyan` and `/opt/conda`

## Build the image
	docker build -t obidam/base .
	
## Run it:
	docker run -it --rm -p 8888:8888 obidam/base
	
## Check on conda package list:
	docker run -it --rm obidam/base start.sh "conda list"