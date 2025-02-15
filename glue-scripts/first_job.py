import sys
import boto3
import pyspark
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, upper

# Initialize a Spark session
spark = SparkSession.builder \
    .appName("GlueETL") \
    .config("spark.sql.debug.maxToStringFields", "100") \
    .getOrCreate()



# S3 paths
input_s3_path = "s3://your-source-bucket/input-data/"
output_s3_path = "s3://your-target-bucket/output-data/"

# Read data from S3
df = spark.read.csv(input_s3_path, header=True, inferSchema=True)

# Transform: Convert 'name' column to uppercase
df_transformed = df.withColumn("name", upper(col("name")))

# Write transformed data back to S3 in Parquet format
df_transformed.write.mode("overwrite").parquet(output_s3_path)

print("ETL Job Completed Successfully!")