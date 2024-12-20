terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.74"
    }
  }

  required_version = ">= 1.9.8"
}

provider "aws" {
  region              = var.aws_region
  allowed_account_ids = [var.allowed_account_id]
  default_tags {
    tags = {
      environment  = var.env_name
      squad        = var.squad
      "managed-by" = "Terraform"
      repository   = var.repository
    }
  }
}

