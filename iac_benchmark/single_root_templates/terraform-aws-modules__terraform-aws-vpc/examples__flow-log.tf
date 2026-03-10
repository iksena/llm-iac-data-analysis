# ── main.tf ────────────────────────────────────
provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "eu-west-1"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-vpc"
    GithubOrg  = "terraform-aws-modules"
  }
}

################################################################################
# Flow Log
################################################################################

module "flow_log" {
  source = "../../modules/flow-log"

  name   = local.name
  vpc_id = module.vpc.vpc_id

  tags = local.tags
}

module "flow_log_cloudwatch_external" {
  source = "../../modules/flow-log"

  name   = "${local.name}-cloudwatch-external"
  vpc_id = module.vpc.vpc_id

  create_cloudwatch_log_group = false
  log_destination             = aws_cloudwatch_log_group.flow_log.arn

  create_iam_role = false
  iam_role_arn    = aws_iam_role.flow_log_cloudwatch.arn

  tags = local.tags
}

module "flow_log_s3" {
  source = "../../modules/flow-log"

  name   = "${local.name}-s3"
  vpc_id = module.vpc.vpc_id

  log_destination_type = "s3"
  log_destination      = module.s3_bucket.s3_bucket_arn

  tags = local.tags
}

module "flow_log_s3_parquet" {
  source = "../../modules/flow-log"

  name   = "${local.name}-s3-parquet"
  vpc_id = module.vpc.vpc_id

  log_destination_type = "s3"
  log_destination      = module.s3_bucket.s3_bucket_arn
  destination_options = {
    file_format                = "parquet"
    hive_compatible_partitions = true
    per_hour_partition         = true
  }

  tags = local.tags
}

module "disabled" {
  source = "../../modules/flow-log"

  create = false
}

################################################################################
# Supporting Resources
################################################################################

module "vpc" {
  source = "../../"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]

  tags = local.tags
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 5.0"

  bucket_prefix = "${local.name}-"
  force_destroy = true

  # Policy works for flow logs as well
  attach_waf_log_delivery_policy = true

  tags = local.tags
}

resource "aws_cloudwatch_log_group" "flow_log" {
  name_prefix = "/aws/flow-log/vpc/${module.vpc.vpc_id}/${local.name}-external-"

  retention_in_days = 7

  tags = local.tags
}

resource "aws_iam_role" "flow_log_cloudwatch" {
  name_prefix = "${local.name}-external-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "VPCFlowLogsAssume"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      },
    ]
  })

  tags = local.tags
}

resource "aws_iam_role_policy" "flow_log_cloudwatch" {
  name_prefix = "${local.name}-external-"
  role        = aws_iam_role.flow_log_cloudwatch.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
        ]
        Effect   = "Allow"
        Resource = aws_cloudwatch_log_group.flow_log.arn
      },
    ]
  })
}


# ── variables.tf ────────────────────────────────────


# ── outputs.tf ────────────────────────────────────
################################################################################
# Flow Log
################################################################################

output "id" {
  description = "The ID of the Flow Log"
  value       = module.flow_log.id
}

output "arn" {
  description = "The ARN of the Flow Log"
  value       = module.flow_log.arn
}

################################################################################
# CloudWatch Log Group
################################################################################

output "cloudwatch_log_group_name" {
  description = "Name of CloudWatch log group created"
  value       = module.flow_log.cloudwatch_log_group_name
}

output "cloudwatch_log_group_arn" {
  description = "ARN of CloudWatch log group created"
  value       = module.flow_log.cloudwatch_log_group_arn
}

################################################################################
# IAM Role
################################################################################

output "iam_role_name" {
  description = "The name of the IAM role"
  value       = module.flow_log.iam_role_name
}

output "iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the IAM role"
  value       = module.flow_log.iam_role_arn
}

output "iam_role_unique_id" {
  description = "Stable and unique string identifying the IAM role"
  value       = module.flow_log.iam_role_unique_id
}


# ── versions.tf ────────────────────────────────────
terraform {
  required_version = ">= 1.5.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.28"
    }
  }
}
