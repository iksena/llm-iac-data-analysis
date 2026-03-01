Below is a complete Terraform configuration that meets the requirements. It creates a Route 53 hosted zone called "primary," a CloudWatch log group named "aws_route53_example_com," and a CloudWatch log resource policy named "route53-query-logging-policy" that allows Route 53 to create a log stream and put log events. Finally, it configures a Route 53 query logging configuration that sends logs to the CloudWatch log group.

<iac_template>
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region for deploying the infrastructure"
  default     = "us-east-1"
}

# Create a Route 53 hosted zone named "primary"
resource "aws_route53_zone" "primary" {
  name = "primary"
}

# Create a CloudWatch log group with the specified name
resource "aws_cloudwatch_log_group" "example" {
  name              = "aws_route53_example_com"
  retention_in_days = 14
}

# Create a resource policy for the CloudWatch log group to allow Route 53 to create log streams and put log events
resource "aws_cloudwatch_log_resource_policy" "route53_policy" {
  policy_name = "route53-query-logging-policy"

  policy_document = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowRoute53",
        Effect    = "Allow",
        Principal = {
          Service = "route53.amazonaws.com"
        },
        Action   = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = aws_cloudwatch_log_group.example.arn
      }
    ]
  })
}

# Configure the Route 53 query logging configuration to send logs to the CloudWatch log group
resource "aws_route53_query_logging_config" "example" {
  cloudwatch_log_group_arn = aws_cloudwatch_log_group.example.arn
  hosted_zone_id           = aws_route53_zone.primary.zone_id
}
</iac_template>