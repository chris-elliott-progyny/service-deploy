variable "env_name" {
  description = "Environment name"
  type        = string
}

variable "service_name" {
  description = "Name of the service"
  type        = string
}

variable "name" {
  description = "SSM param name"
  type        = string
}

variable "description" {
  description = "SSM param description"
  type        = string
}
