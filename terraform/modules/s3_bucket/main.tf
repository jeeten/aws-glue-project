resource "aws_s3_bucket" "glue_scripts" {
  bucket = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "glue_scripts_versioning" {
  bucket = aws_s3_bucket.glue_scripts.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "glue_scripts_policy" {
  bucket = aws_s3_bucket.glue_scripts.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = "*",
        Action = "s3:GetObject",
        Resource = "${aws_s3_bucket.glue_scripts.arn}/*"
      }
    ]
  })
}
