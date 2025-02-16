# aws-glue-project

    # Installing glue intractive mode
    /media/dasarrathi/Shared4/Projects/AWS/python_app/aws_glue_project/env3.10/lib/python3.10/site-packages/aws_glue_interactive_sessions_kernel
[code]
    pip3 install --upgrade jupyter boto3 aws-glue-sessions

    configure jupyter kernal to have glue-pyspark install

    pip3 show aws-glue-sessions

    cd /media/dasarrathi/Shared4/Projects/AWS/python_app/aws_glue_project/env3.10/lib/python3.10/site-packages
    cd aws_glue_interactive_sessions_kernel/
    jupyter-kernelspec install glue_pyspark --user
    jupyter-kernelspec install glue_spark --user

    jupyter notebook

    <code>
    %region us-east-1

    %profile default
    
    %iam_role arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole
    
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
    
    %stop_session

    </code>
    
[code]

    pip3 install --upgrade jupyter boto3 aws-glue-sessions
    # pip3 install pyspark
    # pip3 install git+https://github.com/awslabs/aws-glue-libs.git
    boto3
    pandas
    pyarrow
    s3fs

