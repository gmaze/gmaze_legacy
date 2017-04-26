# coding: utf-8
# 
# This script load ISAS13 netcdf data and save them on hdfs as a pickle file.
# Then the hdfs data are loaded, and some statistics applied with MLLIB.
# 
# IPYTHON_OPTS="notebook --port 8892 --ip='*' --no-browser" pyspark --master yarn-client --driver-memory 2g --executor-memory 4g --num-executors 8 --executor-cores 4
# 
# Copyright (c) 2016, IFREMER
# Code created by Frederic Paul (Ifremer, LOPS) 
# Revision by G. Maze on 2016-10-05: Added more comments

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# "sc" is the SparkContext
print sc.master
print sc.version
sc._conf.getAll()

# Import python stuff

import sys
import os
import glob
import pandas as pd
get_ipython().magic(u'matplotlib inline')

from pyspark.mllib.linalg import Vectors
from pyspark.mllib.regression import LabeledPoint
from pyspark.mllib.clustering import StreamingKMeans
from pyspark.mllib.feature import Word2Vec
from pyspark.mllib.stat import Statistics

from pyspark.mllib.feature import HashingTF
from pyspark.mllib.feature import StandardScaler, StandardScalerModel
from pyspark.mllib.feature import PCA as PCAmllib

from pyspark.mllib.clustering import KMeans as mllibKMeans, KMeansModel as mllibKMeansModel

from pyspark import Row

#
# Define and test the function to load netcdf ISAS data:
#

def get_temp_fast(fpath):
    import netCDF4
    import numpy as np
    ds = netCDF4.Dataset(fpath)
    #print ds.variables['latitude']
    #print ds.variables['TEMP']
    print ds.variables['TEMP']
    temp = ds.variables['TEMP'][:]
    res = []
    
    lat = ds.variables['latitude'][:]
    lon = ds.variables['longitude'][:]
    
	# Load global domain:
    ilat = np.where((lat > -100) & (lat < 100))[0]
    ilon = np.where((lon > -200) & (lon < 200))[0]
    print ilat.shape, ilat.min(), ilat.max()
    
	# Load first 50 levels of temperature:
    temp = ds.variables['TEMP'][0,:50,ilat.min():ilat.max(),ilon.min():ilon.max()]
    print "Extraction shape", temp.shape
    temp = temp.reshape((50, (len(ilat)-1)*(len(ilon)-1))).T
    print temp.shape
    x, y = np.meshgrid(lon[ilon][:-1], lat[ilat][:-1])
    from pyspark.mllib.linalg import Vectors
    res = [y.ravel(), x.ravel(), temp]
    print res[0].shape, res[1].shape, res[2].shape
    ds.close()
    return res
#print len(get_temp_fast('/toto/ISAS_LPO/ANA_ISAS13/field/2012/ISAS13_20121015_fld_TEMP.nc'))

test = True
if test:
    rdd = sc.parallelize(['/toto/ANA_ISAS13/field/2012/ISAS13_20121015_fld_TEMP.nc'])
    rdd_res = rdd.map(get_temp_fast)
    rdd_temp = rdd_res.flatMap(lambda x: Vectors.dense(x[2]))
    print rdd_temp.take(1)[0].shape
    print rdd_temp.count()    

#
# Load 1 year of monthly ISAS13 data
# (This should be done only once)
# 
flist = glob.glob('/toto/ISAS_LPO/ANA_ISAS13/field/2012/*TEMP.nc')
rdd = sc.parallelize(flist)
rdd_res = rdd.map(get_temp_fast) #.cache() # pas assez de memoire...

# and save the RDD as a pickle file distributed in hdfs
print rdd_res.count()
rdd_res.saveAsPickleFile('hdfs://br156-161.ifremer.fr:8020/tmp/venthsalia_hdp/rdd.pkl')


#
# Ok, reload the data
#
rdd_loaded = sc.pickleFile('hdfs://br156-161.ifremer.fr:8020/tmp/venthsalia_hdp/rdd.pkl')
rdd_loaded = rdd_loaded.cache()
rdd_loaded.count()
rdd_b = rdd_loaded.flatMap(lambda x:x[2]).map(lambda x: Vectors.dense(x))
print rdd_b.count()
print rdd_b.take(1)

#
# Profiles standardisation
#
new_scalar = StandardScaler(withMean=True, withStd=True).fit(rdd_b)  
print type(new_scalar)
scaler3 = new_scalar.transform(rdd_b)

#
# Profiles compression with PCA
#
model = PCAmllib(10).fit(scaler3)
print type(model)
transformed = model.transform(scaler3)
print type(transformed)
print transformed.count()
print transformed.first()

# 
# Train a Profiles classification model with KMean
#
NBCLUSTERS=8
INITMODE='kmean||'   # kmean|| or random
clusters = mllibKMeans.train(
                transformed, 
                NBCLUSTERS, maxIterations=100, 
                initializationMode=INITMODE)
# Rq: Option "runs=5" has been deprecated in 1.6.0

#clusters.save(sc, PROJDIR+'/tmp/ModelTest2')
#clusters.save(sc, MODEL_SAVE_PATH)

dfc = pd.DataFrame(clusters.clusterCenters)
print type(clusters)
print dfc.head(NBCLUSTERS)

#
# Classify profiles:
#
res = clusters.predict(transformed)
print type(res)
print res.count()
