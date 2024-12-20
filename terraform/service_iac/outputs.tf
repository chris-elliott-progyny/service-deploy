output "env_name" {
  description = "Environment Name"
  value       = var.env_name
}

output "service_name" {
  description = "Service Name"
  value       = var.service_name
}

output "service_security_group" {
  description = "Service security group"
  value       = module.service_security_group
}

output "rds_clusters" {
  description = "Map of RDS Clusters configs"
  value       = module.rds_clusters
}

output "dynamodb_tables" {
  description = "Map of DynamoDB Table configs"
  value       = module.dynamodb_tables
}

output "s3_buckets" {
  description = "Map of S3 Bucket configs"
  value       = module.s3_buckets
}

output "sqs_queues" {
  description = "Map of SQS Queies configs"
  value       = module.sqs_queues
}

output "ssm_params" {
  description = "Map of additional ssm_params"
  value       = module.additional_params
}


# output "network_lookup" {
#   description = "Network config"
#   value       = module.network_lookup
# }

# output "eks_alb_target_group_arn" {
#   description = "Network config"
#   value       = module.service_alb_target_group.alb_target_group_arn
# }
