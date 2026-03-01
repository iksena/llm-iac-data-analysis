Below is the complete Terraform program. This configuration creates a public Route 53 hosted zone (with a tag "Name" of "primary"), a CloudWatch log group named "aws_route53_example_com", a CloudWatch log resource policy named "route53-query-logging-policy" (which allows the Route 53 service to create log streams and put log events on that log group), and finally sets up the Route 53 query logging configuration to send query logs to the log group.

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
  region = "us-west-2"
}

# Create a public Route53 hosted zone.
resource "aws_route53_zone" "primary_zone" {
  name = "example.com"

  tags = {
    Name = "primary"
  }
}

# Create a CloudWatch Log Group for Route53 query logging.
resource "aws_cloudwatch_log_group" "route53_log_group" {
  name              = "aws_route53_example_com"
  retention_in_days = 14
}

# Define a CloudWatch Log Resource Policy that allows Route53 to create log streams and put log events.
resource "aws_cloudwatch_log_resource_policy" "route53_policy" {
  policy_name     = "route53-query-logging-policy"

  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "route53.amazonaws.com"
        }
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        # Allow access to any log stream within the log group.
        Resource = "${aws_cloudwatch_log_group.route53_log_group.arn}:*"
      }
    ]
  })
}

# Configure the Route53 Query Logging configuration to send logs to the CloudWatch log group.
resource "aws_route53_query_logging_config" "query_log_config" {
  cloudwatch_log_group_arn = aws_cloudwatch_log_group.route53_log_group.arn
  hosted_zone_id           = aws_route53_zone.primary_zone.zone_id
}
</iac_template>