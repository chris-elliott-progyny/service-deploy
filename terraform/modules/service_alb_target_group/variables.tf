variable "service_name" {
  description = "Name of service"
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

variable "dns_zone_id" {
  description = "DNS zone id"
  type        = string
}

variable "service_config" {
  description = "Service configuration"
  type = object({
    health_check_path = string
    hostname          = string
    protocol          = optional(string, "HTTP")
    port              = number
  })
}

variable "eks_common_alb" {
  description = "EKS common alb"
  type = object({
    dns_name     = string
    zone_id      = string
    listener_arn = string
  })
}
