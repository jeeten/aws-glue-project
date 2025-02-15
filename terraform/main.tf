module "s3_bucket" {
  source      = "./modules/s3_bucket"
  bucket_name = "my-glue-scripts-bucket"
}

module "iam_roles" {
  source    = "./modules/iam_roles"
  role_name = "AWSGlueServiceRole"
  s3_bucket = module.s3_bucket.bucket_name
}

module "glue_job" {
  source          = "./modules/glue_job"
  job_name        = "my-glue-job"
  role_arn        = module.iam_roles.glue_role_arn
  s3_bucket       = module.s3_bucket.bucket_name
  script_key      = "glue-scripts/glue_script.py"
  number_of_workers = 2
}

# module "dynamodb" {
#   source     = "./modules/dynamodb"
#   table_name = "terraform-lock"
# }
