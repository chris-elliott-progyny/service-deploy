output "name" {
  description = "Security group name"
  value       = local.security_group_name
}

output "id" {
  description = "Security group id"
  value       = aws_security_group.service.id
}

output "service_security_group_id_param" {
  description = "Service security_group id ssm param name"
  value       = aws_ssm_parameter.service_security_group_id.name
}
