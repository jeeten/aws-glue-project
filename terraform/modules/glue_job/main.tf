resource "aws_glue_job" "my_glue_job" {
  name     = var.job_name
  role_arn = var.role_arn

  command {
    name            = "glueetl"
    script_location = "s3://${var.s3_bucket}/${var.script_key}"
    python_version  = "3.10"
  }

  glue_version      = "4.0"
  worker_type       = "G.1X"
  number_of_workers = var.number_of_workers
}
