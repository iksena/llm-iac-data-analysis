Below is an explanation of the Terraform program that meets the business need. The configuration does the following:

• Configures the AWS provider in the us-east-1 region.
• Creates a Route 53 hosted zone named "primary".
• Creates a CloudWatch log group named "aws_route53_example_com" for storing Route 53 query logs.
• Defines a CloudWatch log resource policy (named "route53-query-logging-policy") that permits the Route 53 service (route53.amazonaws.com) to create log streams and put log events.
• Configures a Route 53 query logging configuration that sends logs from the "primary" zone into the specified CloudWatch log group.

Below is the complete deployable Terraform HCL configuration:

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
  region = "us-east-1"
}

# Create a Route 53 hosted zone named "primary"
resource "aws_route53_zone" "primary" {
  name = "primary"
}

# Create a CloudWatch Log Group named "aws_route53_example_com"
resource "aws_cloudwatch_log_group" "example" {
  name              = "aws_route53_example_com"
  retention_in_days = 14
}

# Define a CloudWatch Log Resource Policy that allows Route53 to create streams and put log events
data "aws_iam_policy_document" "route53_query_logging_policy" {
  statement {
    sid    = "Route53QueryLogging"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["route53.amazonaws.com"]
    }

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    
    resources = ["*"]
  }
}

resource "aws_cloudwatch_log_resource_policy" "route53_logging_policy" {
  policy_name     = "route53-query-logging-policy"
  policy_document = data.aws_iam_policy_document.route53_query_logging_policy.json
}

# Create a Route 53 Query Logging Config to send query logs from the hosted zone to the CloudWatch Log Group
resource "aws_route53_query_logging_config" "query_logging" {
  hosted_zone_id           = aws_route53_zone.primary.zone_id
  cloudwatch_log_group_arn = aws_cloudwatch_log_group.example.arn
}
</iac_template>