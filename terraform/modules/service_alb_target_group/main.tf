locals {
  ssm_param_path = "${var.env_name}/${var.service_name}/service_alb_target_group"
}

resource "aws_lb_target_group" "service" {
  name        = "${var.env_name}-${var.service_name}"
  port        = var.service_config.port
  protocol    = var.service_config.protocol
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    enabled             = true
    interval            = 30
    path                = var.service_config.health_check_path
    timeout             = 15
    healthy_threshold   = 5
    unhealthy_threshold = 5
    matcher             = 200
    protocol            = var.service_config.protocol
    port                = var.service_config.port
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "service" {
  listener_arn = var.eks_common_alb.listener_arn
  condition {
    host_header {
      values = [var.service_config.hostname]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service.arn
  }
  depends_on = [
    aws_lb_target_group.service
  ]
}

resource "aws_route53_record" "service" {
  zone_id = var.dns_zone_id
  name    = var.service_config.hostname
  type    = "A"

  alias {
    name                   = "dualstack.${var.eks_common_alb.dns_name}"
    zone_id                = var.eks_common_alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_ssm_parameter" "service_alb_target_group_arn" {
  name        = "/${local.ssm_param_path}/arn"
  description = "Service alb target_group arn"
  type        = "SecureString"
  value       = aws_lb_target_group.service.arn
}
