output "alb_target_group_arn_param" {
  description = "ALB target_group arn ssm param name"
  value       = aws_ssm_parameter.service_alb_target_group_arn.name
}
