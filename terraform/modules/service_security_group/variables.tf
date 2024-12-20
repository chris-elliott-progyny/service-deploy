variable "name" {
  description = "DynamoDB Table Name"
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

variable "vpc_id" {
  description = "VPC id"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC cidr"
  type        = string
}

variable "service_port" {
  description = "Service port"
  type        = number
}
