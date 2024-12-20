#! /bin/bash

set -eu

# Args
TF_STACK=$1
TF_PATH=./service-deploy/terraform/$TF_STACK
case $2 in
  plan)
    TF_COMMAND=$2
    ;;
  apply)
    TF_COMMAND="$2 -auto-approve"
    ;;
  *)
    echo "Terraform command not set"
    ;;
esac

# TODO - populated by the pipeline
# Terraform Backend ENVs
TF_STATE_AWS_REGION="us-west-2"
TF_STATE_BUCKET="terraform-state-203918842470"
TF_STATE_DYNAMODB_TABLE="terraform-state-203918842470"

export TF_VAR_service_name="dagster"
export TF_VAR_env_name="etech-dev"
export TF_VAR_aws_region="us-east-2"
export TF_VAR_allowed_account_id="203918842470"

# ROOT_PATH=../../../
SERVICE_TFVARS=$(PWD)/service.tfvars
ENV_TFVARS=$(PWD)/$TF_VAR_env_name-iac.tfvars

touch $SERVICE_TFVARS
touch $ENV_TFVARS

terraform -chdir=$TF_PATH init \
    -backend-config="bucket=$TF_STATE_BUCKET" \
    -backend-config="dynamodb_table=$TF_STATE_DYNAMODB_TABLE" \
    -backend-config="key=services/$TF_VAR_service_name/$TF_STACK.tfstate" \
    -backend-config="region=$TF_STATE_AWS_REGION"

terraform -chdir=$TF_PATH $TF_COMMAND \
  -var-file=$SERVICE_TFVARS \
  -var-file=$ENV_TFVARS
