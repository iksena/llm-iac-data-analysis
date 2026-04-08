terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

module "common" {
  source               = "../pipeline_common"
  pipeline             = var.pipeline_name
  src_org              = var.src_org
  src_repo             = var.src_repo
  codeconnection_arn   = var.codeconnection_arn
  github_token         = var.github_token
  vpc_config           = var.vpc_config
  sns_topic_arn        = var.sns_topic_arn
  access_log_bucket_id = var.access_log_bucket_id
  admin_roles          = var.admin_roles
  tags                 = var.tags
}
