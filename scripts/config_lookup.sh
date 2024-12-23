#! /bin/bash

set -eu

# Args
TF_PATH=./service-deploy/terraform/config_lookup

export TF_VAR_service_name=$SERVICE_NAME
export TF_VAR_env_name=$ENV_NAME
export TF_VAR_aws_region=$AWS_REGION
export TF_VAR_allowed_account_id=$ALLOWED_ACCOUNT_ID
export TF_VAR_namespace=$NAMESPACE

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
