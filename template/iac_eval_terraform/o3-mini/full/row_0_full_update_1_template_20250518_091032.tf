Below is the description followed by the complete Terraform configuration:

Description:
This Terraform program deploys the necessary AWS resources to enable Route 53 query logging to CloudWatch Logs. First, an AWS CloudWatch Logs log group is created and named "aws_route53_example_com." Then, a CloudWatch Logs resource policy named "route53-query-logging-policy" is defined to allow Route 53 to create log streams and put log events into the log group. A Route 53 public hosted zone is created with the name "primary" (per the business requirement). Finally, the Route 53 query log configuration is set up by associating the log group with the hosted zone so that DNS query logs will be streamed to CloudWatch Logs.

Below is the complete Terraform HCL configuration:

<iac_template>
terraform {
  required_version = ">= 0.13"

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
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

# Data sources to retrieve caller identity and partition for log resource policy
data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

# CloudWatch Log Group for Route 53 query logging
resource "aws_cloudwatch_log_group" "example" {
  name              = "aws_route53_example_com"
  retention_in_days = 14
}

# CloudWatch Log Resource Policy to allow Route 53 service to write logs
resource "aws_cloudwatch_log_resource_policy" "route53_policy" {
  policy_name     = "route53-query-logging-policy"
  policy_document = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid       = "route53QueryLogging"
        Effect    = "Allow"
        Principal = {
          Service = "route53.amazonaws.com"
        }
        Action   = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:${data.aws_partition.current.partition}:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.example.name}:*"
      }
    ]
  })
}

# Route 53 Hosted Zone named "primary"
resource "aws_route53_zone" "primary_zone" {
  name = "primary"
}

# Route 53 Query Log configuration to stream DNS query logs to CloudWatch Logs log group
resource "aws_route53_query_log" "example" {
  zone_id                       = aws_route53_zone.primary_zone.zone_id
  cloudwatch_logs_log_group_arn = aws_cloudwatch_log_group.example.arn
}
</iac_template>