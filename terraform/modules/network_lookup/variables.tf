variable "env_name" {
  description = "Environment name"
  type        = string
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "dns_zone" {
  description = "DNS zone"
  type        = string
  default     = null
}
