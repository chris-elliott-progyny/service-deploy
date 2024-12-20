output "name" {
  description = "Name of service"
  value       = var.service_name
}

# output "env_name" {
#   description = "Environment name suffix to use for the shared environment resources"
#   value       = var.env_name
# }

output "iam_role_name" {
  description = "Service IAM role name"
  value       = module.irsa_role.iam_role_name
}

# output "iam_role_arn" {
#   description = "Service IAM role arn"
#   value       = module.irsa_role.iam_role_arn
# }

output "service_policies" {
  description = "Combined service policy"
  value       = data.aws_iam_policy_document.service_policies.json
}

output "service_iam_role_arn_param" {
  description = "Service iam_role arn ssm param name"
  value       = aws_ssm_parameter.service_iam_role_arn.name
}
