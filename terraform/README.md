cd terraform
terraform init
terraform apply -var-file=env/dev.tfvars -auto-approve