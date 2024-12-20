locals {
  # convert hyphens to underscores
  param_name        = replace(var.name, "-", "_")
  placeholder_value = "PLACEHOLDER"
}

resource "aws_ssm_parameter" "this" {
  name        = "/${var.env_name}/${var.service_name}/additional_params/${local.param_name}"
  description = var.description
  type        = "SecureString"
  value       = local.placeholder_value
}
