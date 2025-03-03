import sys

from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.utils import getResolvedOptions
from awsglue.transforms import *
from pyspark.sql.functions import *
from awsglue.job import Job
import pandas as pd
from awsglue.dynamicframe import DynamicFrame

#initialize spark context
sparkContext = SparkContext()

# create Glue wrapper on spark Context
glueContext = GlueContext(sparkContext)

# create Glue PySpark session
spark_session = glueContext.spark_session

# Create Glue Dynamic Dataframe


# Create Glue Job
job = Job(glueContext)

# Initialize job with a name and resolved arguments
job.init("my_first_job",getResolvedOptions(sys.argv, []))

dynamicDataFrame = glueContext.create_dynamic_frame.from_options(connection_type="s3", connection_options={"paths": ["s3://ogg-dev/raw/year=2025/month=02/day=19/"]}, format="csv",format_options={"withHeader": True})

"""'__class__', '__delattr__', '__dict__', '__dir__', '__doc__', '__eq__', '__format__', '__ge__', '__getattribute__', '__gt__', '__hash__', '__init__',
 '__init_subclass__', '__le__', '__lt__', '__module__', '__ne__', '__new__', '__reduce__', '__reduce_ex__', '__repr__', '__setattr__', '__sizeof__', 
 '__str__', '__subclasshook__', '__weakref__', '_jdf', '_lazy_rdd', '_rdd', '_sc', '_schema', '_ssql_ctx', 'applyMapping', 'apply_mapping', 
 'assertErrorThreshold', 'coalesce', 'count', 'drop_fields', 'errorsAsDynamicFrame', 'errorsCount', 'filter', 'fromDF', 'getNumPartitions', 'glue_ctx', 
 'join', 'map', 'mapPartitions', 'mapPartitionsWithIndex', 'mergeDynamicFrame', 'name', 'printSchema', 'relationalize', 'rename_field', 'repartition',
   'resolveChoice', 'schema', 'select_fields', 'show', 'spigot', 'split_fields', 'split_rows', 'stageErrorsCount', 'toDF', 'unbox', 'union', 'unnest', 
   'unnest_ddb_json', 'with_frame_schema', 'write'"""

## Transform: Filter out invalid rows
# print(dir(dynamicDataFrame))
dynamicDataFrame = dynamicDataFrame.drop_fields(['VMail Message']) #Drop Column from Glue DynamicaDataFram
# Conver DynamicDataFrame to PySparkDataFrame
spark_df = dynamicDataFrame.toDF()
# dynamicDataFrame.toDF().show(5,truncate=False)

spark_df = spark_df.withColumn("Churn", when(col("Churn") == False, lit("Checked")).otherwise(col("Churn")))
spark_df.show(5)
# Convert PySParkDataFrame to Panda Dataframe
# pandaDataFrame = dynamicDataFrame.toDF().toPandas()
# print(pandaDataFrame.to_string(index=False))


# Convert to GlueDynamic DataFrame and save
# output_dynamic_frame = DynamicFrame.fromDF(spark_df, glueContext,"updated_glue_df")
output_dynamic_frame = glueContext.create_dynamic_frame.from_dataframe(spark_df, glueContext)

# Store the transformation file into S3
glueContext.write_dynamic_frame.from_options(
    frame=output_dynamic_frame,
    connection_type="s3",
    connection_options={"path": "s3://ogg-dev/intransit/year=2025/month=02/day=19/"},
    format="parquet"
)

# Commit the job at the end
job.commit()
