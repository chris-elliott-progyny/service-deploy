#https://github.com/terraform-aws-modules/terraform-aws-rds-aurora

locals {
  ssm_param_path               = "${var.env_name}/${var.service_name}/rds_clusters/${var.name}"
  cluster_identifier           = "${var.env_name}-${var.name}"
  preferred_maintenance_window = "sun:05:00-sun:06:00"

  major_engine_version = regex("\\d+", data.aws_rds_engine_version.postgresql.version)

  default_db_cluster_parameters = concat(var.cluster_parameters, [
    {
      name         = "log_min_duration_statement"
      value        = 4000
      apply_method = "immediate"
    },
    {
      name         = "rds.force_ssl"
      value        = 1
      apply_method = "immediate"
    }
  ])
  default_db_parameters = concat(var.db_parameters, [
    {
      name         = "log_min_duration_statement"
      value        = 4000
      apply_method = "immediate"
    }
  ])
}

resource "random_password" "postgresql" {
  length           = 64
  special          = true
  override_special = "~^&()_+{}:|?<>.,"
}

data "aws_rds_engine_version" "postgresql" {
  engine  = "aurora-postgresql"
  version = var.rds_version
}

module "aurora_postgresql_v2" {
  source = "terraform-aws-modules/rds-aurora/aws"

  name                        = local.cluster_identifier
  engine                      = data.aws_rds_engine_version.postgresql.engine
  engine_mode                 = "provisioned"
  engine_version              = data.aws_rds_engine_version.postgresql.version
  storage_type                = var.storage_type
  storage_encrypted           = true
  manage_master_user_password = false
  master_username             = var.master_username
  master_password             = random_password.postgresql.result
  database_name               = var.database_name

  vpc_id               = var.vpc_id
  db_subnet_group_name = var.database_subnet_group_name
  security_group_rules = {
    # vpc_ingress = {
    #   cidr_blocks = var.private_subnets_cidr_blocks
    # }
    service_ingress = {
      source_security_group_id = var.service_security_group
    }
  }

  create_db_cluster_parameter_group      = true
  db_cluster_parameter_group_name        = local.cluster_identifier
  db_cluster_parameter_group_family      = "${data.aws_rds_engine_version.postgresql.engine}${local.major_engine_version}"
  db_cluster_parameter_group_description = "${local.cluster_identifier} cluster parameter group"
  db_cluster_parameter_group_parameters  = local.default_db_cluster_parameters

  create_db_parameter_group      = true
  db_parameter_group_name        = local.cluster_identifier
  db_parameter_group_family      = "${data.aws_rds_engine_version.postgresql.engine}${local.major_engine_version}"
  db_parameter_group_description = "${local.cluster_identifier} DB parameter group"
  db_parameter_group_parameters  = local.default_db_parameters

  monitoring_interval          = 60
  preferred_maintenance_window = var.preferred_maintenance_window

  apply_immediately         = true
  skip_final_snapshot       = false
  final_snapshot_identifier = local.cluster_identifier

  enable_http_endpoint               = false
  serverlessv2_scaling_configuration = var.scaling_configuration

  instance_class = "db.serverless"
  instances      = var.instances
}
