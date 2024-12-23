#! /bin/bash

# requires terraform, kubectl and helm

set -eu

TF_PATH=./service-deploy/terraform/config_lookup

export TF_VAR_service_name=$SERVICE_NAME
export TF_VAR_env_name=$ENV_NAME
export TF_VAR_aws_region=$AWS_REGION
export TF_VAR_allowed_account_id=$ALLOWED_ACCOUNT_ID
export TF_VAR_namespace=$NAMESPACE

SERVICE_TFVARS=$(PWD)/service.tfvars
ENV_TFVARS=$(PWD)/$TF_VAR_env_name-iac.tfvars
HELM_CHART_PATH=$(PWD)/service-deploy/helm/charts/$HELM_CHART
touch $SERVICE_TFVARS
touch $ENV_TFVARS

terraform -chdir=$TF_PATH init

# TODO abusable
terraform -chdir=$TF_PATH apply \
    -auto-approve \
    -no-color \
    -var-file=$SERVICE_TFVARS \
    -var-file=$ENV_TFVARS

HELM_VALUES="$(PWD)/helm_values.yaml"
GENERATED_HELM_VALUES="$(PWD)/generated_helm_values.yaml"

touch $HELM_VALUES

helm upgrade -i \
    -n $NAMESPACE \
    --set envName=$ENV_NAME \
    --set serviceName=$SERVICE_NAME \
    -f $HELM_VALUES \
    -f $GENERATED_HELM_VALUES \
    $SERVICE_NAME $HELM_CHART_PATH

sleep 2
kubectl -n $NAMESPACE get po