terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

resource "aws_iam_role" "eb_lifecycle_role" {
  name = "eb-lifecycle-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "elasticbeanstalk.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Optionally attach a policy if additional permissions are needed.
# For app version lifecycle, AWS Elastic Beanstalk handles much of the cleanup.
# You may attach additional policies as required by your business needs.
resource "aws_iam_role_policy" "eb_lifecycle_policy" {
  name   = "eb-lifecycle-policy"
  role   = aws_iam_role.eb_lifecycle_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:DeleteObject"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_elastic_beanstalk_application" "example" {
  name        = "example-eb-app"
  description = "Elastic Beanstalk Application with App Version Lifecycle policy retaining versions for 5 days"

  appversion_lifecycle {
    service_role           = aws_iam_role.eb_lifecycle_role.arn
    delete_source_from_s3  = true
    max_age_in_days        = 5
  }
}