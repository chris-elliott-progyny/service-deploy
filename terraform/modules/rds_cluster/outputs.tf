output "cluster_identifier" {
  description = "RDS Cluster identifier"
  value       = local.cluster_identifier
}

output "cluster_engine_version_actual_param" {
  description = "RDS actual version"
  value       = aws_ssm_parameter.cluster_engine_version_actual.name
}

output "master_username_parm" {
  description = "RDS cluster master username ssm param name"
  value       = aws_ssm_parameter.master_username.name
  sensitive   = true
}

output "master_password" {
  description = "RDS cluster master password ssm param name"
  value       = aws_ssm_parameter.master_password.name
  sensitive   = true
}

output "endpoint_param" {
  description = "RDS cluster endpoint ssm param name"
  value       = aws_ssm_parameter.endpoint.name
}

output "reader_endpoint_param" {
  description = "RDS cluster reader endpoint ssm param name"
  value       = aws_ssm_parameter.reader_endpoint.name
}

output "port_param" {
  description = "RDS cluster port ssm param name"
  value       = aws_ssm_parameter.port.name
}
