locals {
  helm_values = {
    serviceName = "${var.service_name}"
    envName     = var.env_name
    serviceAccount = {
      # create = true
      # name   = var.service_name
      annotations = {
        "eks.amazonaws.com/role-arn" = nonsensitive(data.aws_ssm_parameter.service_iam_role_arn.value)
      }
    }

    # TODO add node selector that can be a looked up
    # nodeSelector = {
    #   "eks.amazonaws.com/nodegroup" = "data-eks-nodegroup-20241205014209200500000003"
    # }

    serviceTargetGroupArn = nonsensitive(data.aws_ssm_parameter.service_alb_target_group_arn.value)
    serviceSecurityGroup  = nonsensitive(data.aws_ssm_parameter.service_security_group_id.value)
  }
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
  content  = yamlencode(local.helm_values)
  filename = "${path.cwd}/generated_helm_values.yaml"
}
