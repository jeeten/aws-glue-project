import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.dynamicframe import DynamicFrame

# Initialize Glue Context
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session

# Read data from S3
input_path = "s3://my-source-bucket/input-data/"
df = spark.read.json(input_path)

# Transform Data
df_transformed = df.withColumnRenamed("old_column", "new_column")

# Write Data to S3
output_path = "s3://my-target-bucket/output-data/"
df_transformed.write.mode("overwrite").parquet(output_path)

print("Glue job completed successfully!")