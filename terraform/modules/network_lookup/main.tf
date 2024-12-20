locals {
  vpc_id                     = data.aws_vpc.main.id
  vpc_cidr                   = data.aws_vpc.main.cidr_block
  private_subnet_ids         = data.aws_subnets.private_subnets.ids
  public_subnet_ids          = data.aws_subnets.public_subnets.ids
  private_subnet_cidr_blocks = [for id in data.aws_subnet.private : id.cidr_block]
  database_subnet_group_name = var.vpc_name
}

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }
  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }
}

data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }
  filter {
    name   = "tag:Name"
    values = ["*public*"]
  }
}

data "aws_subnet" "private" {
  for_each = toset(local.private_subnet_ids)
  id       = each.value
}

data "aws_lb" "eks_common" {
  name = "${var.eks_cluster_name}-alb"
}

data "aws_lb_listener" "eks_common_443" {
  load_balancer_arn = data.aws_lb.eks_common.arn
  port              = 443
}

data "aws_security_group" "eks_common_alb" {
  name = "${var.eks_cluster_name}-alb"
}

data "aws_route53_zone" "main" {
  name = "${var.dns_zone}."
}
