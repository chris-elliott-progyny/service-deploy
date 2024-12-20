
variable "aws_account_id" {
  description = "AWS account id"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "service_name" {
  description = "Name of the service"
  type        = string
}

variable "env_name" {
  description = "Environment name"
  type        = string
}

variable "iam_access" {
  description = "Map of iam access"
  type        = any
}

variable "oidc_provider_arn" {
  description = "oidc provider arn to use for federated authentication"
  type        = string
}

variable "eks_namespace" {
  description = "EKS cluster controller namespace"
  type        = string
}
