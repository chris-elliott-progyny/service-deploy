
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

variable "dynamodb_tables" {
  description = "Service dynamodb tables"
  type = map(object({
    table_hash = object({
      key_name = string
      key_type = string
    })
    table_capacity = object({
      read  = number
      write = number
    })
  }))
  default = {}
}

variable "rds_clusters" {
  description = "Service RDS clusters"
  type = map(object({
    rds_version   = number
    database_name = string
    storage_type  = optional(string, "aurora")
    scaling_configuration = object({
      min_capacity = number
      max_capacity = number
    })
  }))
  default = {}
}

variable "s3_buckets" {
  description = "Service s3 buckets"
  type = map(object({
    versioning_enabled = optional(bool, true)
  }))
  default = {}
}

variable "sqs_queues" {
  description = "Service dynamodb tables"
  type = map(object({
    disable_dead_letter_queue  = optional(bool, false)
    delay_seconds              = optional(number, 0)
    max_message_size           = optional(number, 1024)
    message_rentention_seconds = optional(number, 30)
    timeout                    = optional(number, 5)
  }))
  default = {}
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

variable "additional_params" {
  description = "List of additional ssm_params to create"
  type = list(object({
    name        = string
    description = string
  }))
  default = []
}
