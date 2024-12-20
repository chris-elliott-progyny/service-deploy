output "vpc_name" {
  description = "VPC name"
  value       = var.vpc_name
}

output "vpc_id" {
  description = "VPC id"
  value       = local.vpc_id
}

output "vpc_cidr" {
  description = "VPC cidr"
  value       = local.vpc_cidr
}

output "private_subnet_ids" {
  description = "Private subnet ids"
  value       = local.private_subnet_ids
}

output "public_subnet_ids" {
  description = "Public subnet ids"
  value       = local.public_subnet_ids
}

output "private_subnet_cidr_blocks" {
  description = "Private subnet cidrs"
  value       = local.private_subnet_cidr_blocks
}

output "database_subnet_group_name" {
  description = "VPC database subnet group name"
  value       = local.database_subnet_group_name
}

output "eks_alb_endpoint" {
  description = "EKS alb listener arn"
  value       = data.aws_lb_listener.eks_common_443.arn
}

output "eks_alb_dns_name" {
  description = "EKS alb dns name"
  value       = data.aws_lb.eks_common.dns_name
}

output "eks_alb_zone_id" {
  description = "EKS alb zone id"
  value       = data.aws_lb.eks_common.zone_id
}

output "eks_alb_listener_arn" {
  description = "EKS alb listener arn"
  value       = data.aws_lb_listener.eks_common_443.arn
}

output "dns_zone_id" {
  description = "DNS zone id"
  value       = data.aws_route53_zone.main.id
}
