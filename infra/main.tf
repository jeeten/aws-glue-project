# glue_role_arn = arn:aws:iam::248189927181:role/glue_interactive_role

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# S3 Buckets
resource "aws_s3_bucket" "script" {
  bucket = "dev-etl-job"
}

resource "aws_s3_bucket" "raw_data" {
  bucket = "dev-batch-raw-data"
}

resource "aws_s3_bucket" "intransit" {
  bucket = "dev-batch-intransit"
}

resource "aws_s3_bucket" "processed_data" {
  bucket = "dev-batch-processed-data"
}

resource "aws_s3_bucket" "logs" {
  bucket = "dev-etl-job-log"
}

resource "aws_s3_bucket" "archive" {
  bucket = "dev-etl-job-archive"
}

resource "aws_s3_bucket" "backup" {
  bucket = "dev-etl-job-backup"
}

resource "aws_s3_bucket" "error" {
  bucket = "dev-etl-job-error"
}


resource "aws_iam_policy" "pass_role_policy" {
  name   = "GluePassRolePolicy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "iam:PassRole"
        Resource = aws_iam_role.glue_role.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "pass_role_attach" {
  role       = aws_iam_role.glue_role.name
  policy_arn = aws_iam_policy.pass_role_policy.arn
}

# IAM Role for Glue
resource "aws_iam_role" "glue_role" {
  name = "glue-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Service": "glue.amazonaws.com" },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}




# Attach AWS Managed Glue Policy
resource "aws_iam_policy_attachment" "glue_full_access" {
  name       = "glue-full-access"
  roles      = [aws_iam_role.glue_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}


resource "aws_iam_policy_attachment" "glue_s3_access" {
  name       = "glue-s3-access"
  roles      = [aws_iam_role.glue_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}





# Glue Crawler
resource "aws_glue_catalog_database" "my_database" {
  name = "my-glue-db"
}

resource "aws_glue_crawler" "my_crawler" {
  database_name = aws_glue_catalog_database.my_database.name
  name          = "my-crawler"
  role          = aws_iam_role.glue_role.arn

  s3_target {
    path = "s3://${aws_s3_bucket.raw_data.bucket}/"
  }
}

# Glue Job
resource "aws_glue_job" "my_job" {
  name            = "my-glue-job"
  role_arn        = aws_iam_role.glue_role.arn
  timeout         = 30  # Increased timeout
  glue_version    = "4.0"
  
  execution_property {
    max_concurrent_runs = 1
  }

  worker_type       = "G.1X"
  number_of_workers = 2

  command {
    script_location = "s3://${aws_s3_bucket.script.bucket}/scripts/my_glue_script.py"
    name            = "glueetl"
    python_version  = "3"
  }
}

# Redshift Cluster
resource "aws_redshift_cluster" "my_redshift" {
  cluster_identifier        = "my-redshift-cluster"
  database_name             = "analyticsdb"
  master_username          = "adminuser"
  master_password          = "SuperSecurePass1!"
  node_type                = "dc2.large"
  cluster_type             = "single-node"
  skip_final_snapshot      = true
}
