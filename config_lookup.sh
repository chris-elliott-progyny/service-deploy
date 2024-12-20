#! /bin/bash

set -eu

# Args
TF_PATH=./service-deploy/terraform/config_lookup

# TODO - populated by the pipeline
# Terraform vars
export TF_VAR_service_name="dagster"
export TF_VAR_env_name="etech-dev"
export TF_VAR_aws_region="us-east-2"
export TF_VAR_allowed_account_id="203918842470"

SERVICE_TFVARS=$(PWD)/service.tfvars
ENV_TFVARS=$(PWD)/$TF_VAR_env_name-iac.tfvars

touch $SERVICE_TFVARS
touch $ENV_TFVARS

terraform -chdir=$TF_PATH init

terraform -chdir=$TF_PATH apply \
    -auto-approve \
    -no-color \
    -var-file=$SERVICE_TFVARS \
    -var-file=$ENV_TFVARS
