#!/bin/bash

# Upload latest Glue script
./upload_to_s3.sh

# Deploy or update Terraform infrastructure
cd terraform
terraform apply -var-file=env/dev.tfvars -auto-approve
