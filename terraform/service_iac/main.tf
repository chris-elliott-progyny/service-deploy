locals {
  service_hostname = var.service_sub_domain != null ? "${var.service_sub_domain}.${var.dns_zone}" : "${var.service_name}.${var.dns_zone}"
  ssm_params = { for param in var.additional_params : param.name => {
    name        = param.name
    description = param.description
  } }
}

module "network_lookup" {
  source = "../modules/network_lookup"

  vpc_name         = "${var.env_name}-${var.vpc_name}"
  env_name         = var.env_name
  eks_cluster_name = var.eks_cluster_name
  dns_zone         = var.dns_zone
}

module "service_security_group" {
  source = "../modules/service_security_group"

  name         = var.service_name
  env_name     = var.env_name
  service_name = var.service_name
  vpc_id       = module.network_lookup.vpc_id
  vpc_cidr     = module.network_lookup.vpc_cidr
  service_port = var.service_port
}

module "service_alb_target_group" {
  source = "../modules/service_alb_target_group"

  service_name = var.service_name
  env_name     = var.env_name
  vpc_id       = module.network_lookup.vpc_id
  dns_zone_id  = module.network_lookup.dns_zone_id
  service_config = {
    health_check_path = var.service_health_check_path
    hostname          = local.service_hostname
    port              = var.service_port
  }
  eks_common_alb = {
    dns_name     = module.network_lookup.eks_alb_dns_name
    zone_id      = module.network_lookup.eks_alb_zone_id
    listener_arn = module.network_lookup.eks_alb_listener_arn
  }
}

module "rds_clusters" {
  source   = "../modules/rds_cluster"
  for_each = var.rds_clusters

  name                        = each.key
  env_name                    = var.env_name
  service_name                = var.service_name
  rds_version                 = each.value.rds_version
  storage_type                = each.value.storage_type
  database_name               = each.value.database_name
  scaling_configuration       = each.value.scaling_configuration
  vpc_id                      = module.network_lookup.vpc_id
  database_subnet_group_name  = module.network_lookup.database_subnet_group_name
  private_subnets_cidr_blocks = module.network_lookup.private_subnet_cidr_blocks
  service_security_group      = module.service_security_group.id
}

module "dynamodb_tables" {
  source   = "../modules/dynamodb_table"
  for_each = var.dynamodb_tables

  name           = each.key
  env_name       = var.env_name
  table_hash     = each.value.table_hash
  table_capacity = each.value.table_capacity
}

module "s3_buckets" {
  source   = "../modules/s3_bucket"
  for_each = var.s3_buckets

  name               = each.key
  env_name           = var.env_name
  versioning_enabled = each.value.versioning_enabled
}

module "sqs_queues" {
  source   = "../modules/sqs_queue"
  for_each = var.sqs_queues

  name                       = each.key
  env_name                   = var.env_name
  disable_dead_letter_queue  = each.value.disable_dead_letter_queue
  delay_seconds              = each.value.delay_seconds
  max_message_size           = each.value.max_message_size
  message_rentention_seconds = each.value.message_rentention_seconds
}

module "additional_params" {
  source   = "../modules/ssm_params"
  for_each = local.ssm_params

  env_name     = var.env_name
  service_name = var.service_name
  name         = lower(each.value.name)
  description  = each.value.description
}
