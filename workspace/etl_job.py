import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
glueContext = GlueContext(SparkContext.getOrCreate())

medicare_dynamicframe = glueContext.create_dynamic_frame.from_options(
    's3',
    {'paths': ['s3://awsglue-datasets/examples/medicare/Medicare_Hospital_Provider.csv']},
    'csv',
    {'withHeader': True})
print("Count:",medicare_dynamicframe.count())
medicare_dynamicframe.printSchema()

medicare_res = medicare_dynamicframe.resolveChoice(specs = [('Provider Id','cast:long')])
medicare_res.printSchema()


medicare_res.toDF().select('Provider Name').show(10,truncate=False)