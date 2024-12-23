data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "eks_cluster" {
  name = var.eks_cluster_name
}

locals {
  aws_account_id       = data.aws_caller_identity.current.account_id
  identity_oidc_issuer = replace(data.aws_eks_cluster.eks_cluster.identity.0.oidc.0.issuer, "https://", "")
  oidc_provider_arn    = "arn:aws:iam::${local.aws_account_id}:oidc-provider/${local.identity_oidc_issuer}"
  iam_access = concat(
    [for k, v in var.dynamodb_tables : {
      type     = "dynamodb_table"
      access   = "write"
      resource = k
    }],
    [for k, v in var.s3_buckets : {
      type     = "s3_bucket"
      access   = "write"
      resource = k
    }],
    [for k, v in var.sqs_queues : {
      type     = "sqs_queue"
      access   = "write"
      resource = k
    }],
    [for k, v in var.additional_iam_access : {
      type     = v.type
      access   = v.access
      resource = v.resource
    }]
  )
}

module "service_iam_role" {
  source = "../modules/service_iam_role"

  service_name      = var.service_name
  env_name          = var.env_name
  iam_access        = local.iam_access
  aws_region        = var.aws_region
  aws_account_id    = local.aws_account_id
  oidc_provider_arn = local.oidc_provider_arn
  namespace         = var.namespace
}
