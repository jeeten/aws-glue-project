variable "table_name" {
  description = "Name of the DynamoDB table for Terraform state locking"
  default     = "terraform-lock"
}
