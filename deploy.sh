#! /bin/bash

# requires terraform, kubectl and helm

set -eu

TF_PATH=./service-deploy/terraform/config_lookup

# TODO - populated by the pipeline
# Terraform vars
ENV_NAME=etech-dev
SERVICE_NAME=dagster
NAMESPACE=dagster
export TF_VAR_service_name=$SERVICE_NAME
export TF_VAR_env_name=$ENV_NAME
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

HELM_CHART="./service-deploy/helm/charts/third-party/dagster-oss"
HELM_VALUES="$(PWD)/helm_values.yaml"
GENERATED_HELM_VALUES="$(PWD)/generated_helm_values.yaml"

touch $HELM_VALUES

helm upgrade -i \
    -n $NAMESPACE \
    --set envName=$ENV_NAME \
    --set serviceName=$SERVICE_NAME \
    -f $HELM_VALUES \
    -f $GENERATED_HELM_VALUES \
    $SERVICE_NAME $HELM_CHART

sleep 5

kubectl delete pods --selector app.kubernetes.io/instance=$SERVICE_NAME

kubectl get pods --selector app.kubernetes.io/instance=$SERVICE_NAME