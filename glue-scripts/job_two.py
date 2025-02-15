import sys
from pyspark.context import SparkContext
from pyspark.sql import SparkSession
from awsglue.context import GlueContext
from awsglue.job import Job

# Initialize Spark and Glue context
spark = SparkSession.builder \
    .appName("GlueLocalTest") \
    .config("spark.sql.debug.maxToStringFields", "100") \
    .getOrCreate()

sc = spark.sparkContext
glueContext = GlueContext(sc)
job = Job(glueContext)

# Example DataFrame (Replace this with real data sources)
df = spark.createDataFrame(
    [(1, "Alice"), (2, "Bob")],
    ["id", "name"]
)

df.show()

# Example Glue DynamicFrame conversion
# dynamic_frame = glueContext.create_dynamic_frame.from_options(df)
# dynamic_frame.show()

job.commit()