locals {
  security_group_name = "${var.env_name}-${var.name}-service-sg"
  ssm_param_path      = "${var.env_name}/${var.service_name}/service_security_group"
}

resource "aws_security_group" "service" {
  name        = local.security_group_name
  vpc_id      = var.vpc_id
  description = "Service security group"

  tags = { Name = local.security_group_name }

  lifecycle {
    create_before_destroy = true
  }
}

# resource "aws_security_group_rule" "service" {
#   type              = "ingress"
#   from_port         = var.service_port
#   to_port           = var.service_port
#   protocol          = "tcp"
#   cidr_blocks       = [var.vpc_cidr]
#   security_group_id = aws_security_group.service.id
# }

resource "aws_security_group_rule" "service_ingress" {
  type              = "ingress"
  from_port         = 1
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = [var.vpc_cidr]
  security_group_id = aws_security_group.service.id
}

resource "aws_security_group_rule" "service_egress" {
  type              = "egress"
  from_port         = 1
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.service.id
}

resource "aws_ssm_parameter" "service_security_group_id" {
  name        = "/${local.ssm_param_path}/id"
  description = "Service security_group id"
  type        = "SecureString"
  value       = aws_security_group.service.id
}
