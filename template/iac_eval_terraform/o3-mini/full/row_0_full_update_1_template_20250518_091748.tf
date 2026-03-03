Description:
This Terraform configuration sets up Route 53 query logging by creating a hosted zone named "primary", a CloudWatch log group named "aws_route53_example_com", and an associated log stream ("query-log-stream"). In addition, a CloudWatch Logs resource policy named "route53-query-logging-policy" is defined to allow the Route 53 service to create log streams and put log events into the log group. Finally, the configuration creates a Route 53 query logging configuration that directs DNS query logs into the specified log group. The provider is set for the "us-east-1" region by default.

<iac_template>
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

variable "region" {
  description = "AWS region to deploy resources."
  type        = string
  default     = "us-east-1"
}

provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

resource "aws_route53_zone" "primary" {
  name = "primary"
  # Note: Normally, the hosted zone name is expected to be a valid domain name.
}

resource "aws_cloudwatch_log_group" "route53_log_group" {
  name = "aws_route53_example_com"
}

resource "aws_cloudwatch_log_stream" "route53_log_stream" {
  name           = "query-log-stream"
  log_group_name = aws_cloudwatch_log_group.route53_log_group.name
}

resource "aws_cloudwatch_log_resource_policy" "route53_resource_policy" {
  policy_name     = "route53-query-logging-policy"
  policy_document = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowRoute53QueryLogging"
        Effect    = "Allow"
        Principal = {
          Service = "route53.amazonaws.com"
        }
        Action   = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.route53_log_group.name}:*"
      }
    ]
  })
}

resource "aws_route53_query_log" "query_log" {
  hosted_zone_id            = aws_route53_zone.primary.zone_id
  cloudwatch_log_group_arn    = aws_cloudwatch_log_group.route53_log_group.arn
}
</iac_template>