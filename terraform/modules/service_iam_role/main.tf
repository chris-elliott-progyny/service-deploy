locals {
  ssm_param_path = "${var.env_name}/${var.service_name}/service_iam_role"
  role_name      = "${var.env_name}-${var.service_name}-service"
  policies = {
    dynamodb_table = {
      arn_prefix = "arn:aws:dynamodb:${var.aws_account_id}:${var.aws_region}"
      actions = {
        read = [
          "dynamodb:Describe*",
          "dynamodb:Get*",
          "dynamodb:List*",
        ]
        write = ["dynamodb:*"]
      }
    }
    s3_bucket = {
      arn_prefix = "arn:aws:s3::"
      actions = {
        read = [
          "s3:Describe*",
          "s3:Get*",
          "s3:List*",
        ]
        write = ["s3:*"]
      }
    }
    sqs_queue = {
      arn_prefix = "arn:aws:sqs:${var.aws_account_id}:${var.aws_region}"
      actions = {
        read = [
          "sqs:Describe*",
          "sqs:Get*",
          "sqs:List*",
        ]
        write = ["sqs:*"]
      }
    }
  }
}

# TODO use a template instead
data "aws_iam_policy_document" "service_policies" {
  dynamic "statement" {
    for_each = toset(var.iam_access)
    content {
      effect    = "Allow"
      actions   = local.policies[statement.value.type].actions[statement.value.access]
      resources = ["${local.policies[statement.value.type].arn_prefix}:${statement.value.resource}"]
    }
  }
  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameters",
    ]
    resources = [
      "arn:aws:ssm:${var.aws_region}:${var.aws_account_id}:parameter/${var.env_name}/${var.service_name}/*"
    ]
  }
}

resource "aws_iam_policy" "service_policies" {
  name   = "${local.role_name}-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.service_policies.json
}

resource "aws_iam_role_policy_attachment" "parameterstore" {
  role       = module.irsa_role.iam_role_name
  policy_arn = aws_iam_policy.service_policies.arn
}

module "irsa_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version   = "~> 5.0"
  role_name = local.role_name
  oidc_providers = {
    main = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["${var.eks_namespace}:${var.service_name}"]
    }
  }
}

resource "aws_ssm_parameter" "service_iam_role_arn" {
  name        = "/${local.ssm_param_path}/arn"
  description = "Service iam_role arn"
  type        = "SecureString"
  value       = module.irsa_role.iam_role_arn
}
