variable "name" {
  description = "Name of RDS Cluster"
  type        = string
}

variable "env_name" {
  description = "Environment name"
  type        = string
}

variable "service_name" {
  description = "Name of the service"
  type        = string
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
}

variable "database_subnet_group_name" {
  description = "VPC database subnet group name"
  type        = string
}

variable "private_subnets_cidr_blocks" {
  description = "VPC private subnets cidrs"
  type        = list(string)
}

variable "service_security_group" {
  description = "Service security group"
  type        = string
}

variable "master_username" {
  description = "RDS master username"
  type        = string
  default     = "root"
}

variable "rds_version" {
  description = "RDS Version"
  type        = number
}

variable "storage_type" {
  description = "RDS storage type"
  type        = string
  default     = "aurora"
}

variable "database_name" {
  description = "RDS databse name"
  type        = string
}

variable "preferred_maintenance_window" {
  description = "RDS preferred maintenance_window"
  type        = string
  default     = "sun:05:00-sun:06:00"
}

variable "scaling_configuration" {
  description = "RDS scaling configuration"
  type = object({
    min_capacity = optional(number, 1)
    max_capacity = optional(number, 3)
  })
  default = {}
}

variable "cluster_parameters" {
  description = "RDS cluster parameters"
  type = list(object({
    apply_method = string
    name         = string
    value        = string
  }))
  default = []
}

variable "db_parameters" {
  description = "RDS db parameters"
  type = list(object({
    apply_method = string
    name         = string
    value        = string
  }))
  default = []
}

# TODO improve type
variable "instances" {
  description = "Map of cluster instances and any specific/overriding attributes to be created"
  type        = any
  default     = { 1 = {} }
}
