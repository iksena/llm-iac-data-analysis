I'll help you create a Terraform configuration that sets up Route 53 query logging with CloudWatch Log Groups. This configuration will:

1. Create a Route 53 hosted zone named "primary"
2. Create a CloudWatch Log Group for storing Route 53 query logs
3. Create an IAM policy to allow Route 53 to write logs to CloudWatch
4. Configure Route 53 query logging to send logs to the CloudWatch Log Group

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create Route 53 hosted zone
resource "aws_route53_zone" "primary" {
  name = "example.com"
}

# Create CloudWatch Log Group
resource "aws_cloudwatch_log_group" "route53" {
  name              = "aws_route53_example_com"
  retention_in_days = 30
}

# Create IAM policy for Route 53 query logging
data "aws_iam_policy_document" "route53_query_logging_policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["${aws_cloudwatch_log_group.route53.arn}:*"]
    principals {
      identifiers = ["route53.amazonaws.com"]
      type        = "Service"
    }
  }
}

# Create CloudWatch Log Resource Policy
resource "aws_cloudwatch_log_resource_policy" "route53_query_logging" {
  policy_name     = "route53-query-logging-policy"
  policy_document = data.aws_iam_policy_document.route53_query_logging_policy.json
}

# Enable Route 53 Query Logging
resource "aws_route53_query_log" "query_logging" {
  depends_on = [aws_cloudwatch_log_resource_policy.route53_query_logging]

  cloudwatch_log_group_arn = aws_cloudwatch_log_group.route53.arn
  zone_id                  = aws_route53_zone.primary.zone_id
}
</iac_template>

This Terraform configuration:
1. Sets up the AWS provider in the us-east-1 region
2. Creates a Route 53 hosted zone named "example.com"
3. Creates a CloudWatch Log Group named "aws_route53_example_com" with 30-day retention
4. Creates an IAM policy document that allows Route 53 to create log streams and put log events
5. Creates a CloudWatch Log Resource Policy named "route53-query-logging-policy"
6. Enables Route 53 query logging and connects it to the CloudWatch Log Group

The configuration includes all necessary dependencies and permissions for Route 53 query logging to work properly. The depends_on block ensures that the log resource policy is created before enabling query logging.