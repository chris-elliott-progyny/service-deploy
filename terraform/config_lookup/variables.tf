
variable "service_name" {
  description = "Name of the service"
  type        = string
}

variable "allowed_account_id" {
  description = "Allowed AWS Account id"
  type        = string
}

variable "env_name" {
  description = "Environment name"
  type        = string
}

variable "squad" {
  description = "Name of squad"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "repository" {
  description = "Service repository name"
  type        = string
}

variable "vpc_name" {
  description = "Name of vpc"
  type        = string
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "eks_namespace" {
  description = "EKS namespace for deployment"
  type        = string
}

variable "service_health_check_path" {
  description = "Service health check path"
  type        = string
  default     = "/"
}

variable "service_port" {
  description = "Service port"
  type        = number
}

variable "service_sub_domain" {
  description = "Service sub domain"
  type        = string
}

variable "dns_zone" {
  description = "DNS zone"
  type        = string
}

variable "service_config" {
  description = "Map of service config"
  type        = map(string)
  default     = {}
}

variable "service_secrets" {
  description = "Map of service secrets"
  type        = map(string)
  default     = {}
}

