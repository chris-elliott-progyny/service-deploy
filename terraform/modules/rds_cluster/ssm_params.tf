resource "aws_ssm_parameter" "endpoint" {
  name        = "/${local.ssm_param_path}/endpoint"
  description = "RDS cluster endpoint"
  type        = "SecureString"
  value       = module.aurora_postgresql_v2.cluster_endpoint
}

resource "aws_ssm_parameter" "reader_endpoint" {
  name        = "/${local.ssm_param_path}/reader_endpoint"
  description = "RDS cluster reader endpoint"
  type        = "SecureString"
  value       = module.aurora_postgresql_v2.cluster_reader_endpoint
}

resource "aws_ssm_parameter" "port" {
  name        = "/${local.ssm_param_path}/port"
  description = "RDS cluster port"
  type        = "SecureString"
  value       = module.aurora_postgresql_v2.cluster_port
}

resource "aws_ssm_parameter" "master_username" {
  name        = "/${local.ssm_param_path}/master_username"
  description = "RDS cluster root username"
  type        = "SecureString"
  value       = module.aurora_postgresql_v2.cluster_master_username
}

resource "aws_ssm_parameter" "master_password" {
  name        = "/${local.ssm_param_path}/master_password"
  description = "RDS cluster root password"
  type        = "SecureString"
  value       = random_password.postgresql.result
}

resource "aws_ssm_parameter" "database_name" {
  name        = "/${local.ssm_param_path}/database_name"
  description = "RDS cluster database name"
  type        = "SecureString"
  value       = module.aurora_postgresql_v2.cluster_database_name
}

resource "aws_ssm_parameter" "cluster_engine_version_actual" {
  name        = "/${local.ssm_param_path}/cluster_engine_version_actual"
  description = "RDS cluster version"
  type        = "SecureString"
  value       = module.aurora_postgresql_v2.cluster_engine_version_actual
}
