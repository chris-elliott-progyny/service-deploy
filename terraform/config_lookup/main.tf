locals {
  helm_values = {
    serviceName      = var.service_name
    namespace        = var.namespace
    fullnameOverride = var.service_name
    envName          = var.env_name

    # TODO - review pod identity as irsa replacement
    # NOTE this supports standard third-party
    serviceAccount = {
      annotations = {
        "eks.amazonaws.com/role-arn" = nonsensitive(data.aws_ssm_parameter.service_iam_role_arn.value)
      }
    }
    irsaRoleArn = nonsensitive(data.aws_ssm_parameter.service_iam_role_arn.value)

    # TODO add node selector that can be a looked up - EKS automode?
    # nodeSelector = {
    #   "eks.amazonaws.com/nodegroup" = "tbd"
    # }

    serviceTargetGroupArn = nonsensitive(data.aws_ssm_parameter.service_alb_target_group_arn.value)
    serviceSecurityGroup  = nonsensitive(data.aws_ssm_parameter.service_security_group_id.value)
  }
  combined_helm_values = merge(local.helm_values, var.helm_env_overrides)
}

data "aws_ssm_parameter" "service_security_group_id" {
  name = "/${var.env_name}/${var.service_name}/service_security_group/id"
}

data "aws_ssm_parameter" "service_iam_role_arn" {
  name = "/${var.env_name}/${var.service_name}/service_iam_role/arn"
}

data "aws_ssm_parameter" "service_alb_target_group_arn" {
  name = "/${var.env_name}/${var.service_name}/service_alb_target_group/arn"
}

resource "local_file" "generated_helm_values" {
  content  = yamlencode(local.combined_helm_values)
  filename = "${path.cwd}/generated_helm_values.yaml"
}
