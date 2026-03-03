<iac_template>
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
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

resource "aws_iam_role" "elasticbeanstalk_service_role" {
  name = "elasticbeanstalk-service-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "elasticbeanstalk.amazonaws.com"
        },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "elasticbeanstalk_service_policy" {
  name = "elasticbeanstalk-service-policy"
  role = aws_iam_role.elasticbeanstalk_service_role.id

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_elastic_beanstalk_application" "example_app" {
  name        = "example-eb-app"
  description = "Elastic Beanstalk Application with an app version lifecycle retaining versions for 5 days"

  appversion_lifecycle {
    service_role          = aws_iam_role.elasticbeanstalk_service_role.arn
    delete_source_from_s3 = true
    max_age_in_days       = 5
  }
}
</iac_template>