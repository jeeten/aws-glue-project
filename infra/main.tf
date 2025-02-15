provider "aws" {
  region = "us-east-1"  # Change to your preferred AWS region
}

# S3 Buckets
resource "aws_s3_bucket" "raw_data" {
  bucket = "my-raw-data-bucket"
}

resource "aws_s3_bucket" "processed_data" {
  bucket = "my-processed-data-bucket"
}

resource "aws_s3_bucket" "logs" {
  bucket = "my-logs-bucket"
}

resource "aws_s3_bucket" "archive" {
  bucket = "my-archive-bucket"
}

resource "aws_s3_bucket" "backup" {
  bucket = "my-backup-bucket"
}

resource "aws_s3_bucket" "error" {
  bucket = "my-error-bucket"
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

resource "aws_iam_policy_attachment" "glue_s3_access" {
  name       = "glue-s3-access"
  roles      = [aws_iam_role.glue_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_policy_attachment" "glue_redshift_access" {
  name       = "glue-redshift-access"
  roles      = [aws_iam_role.glue_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AWSGlueServiceRole"
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
  name     = "my-glue-job"
  role_arn = aws_iam_role.glue_role.arn

  command {
    script_location = "s3://${aws_s3_bucket.raw_data.bucket}/scripts/my_glue_script.py"
    name            = "glueetl"
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
