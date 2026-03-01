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