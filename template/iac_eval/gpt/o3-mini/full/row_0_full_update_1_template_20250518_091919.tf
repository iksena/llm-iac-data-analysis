The following Terraform program does the following:

• Configures the AWS provider in the "us-east-1" region.
• Creates a Route 53 hosted zone named "primary".
• Defines a CloudWatch Logs log group called "aws_route53_example_com".
• Sets a CloudWatch Logs resource policy (named "route53-query-logging-policy") that allows the Route 53 service (route53.amazonaws.com) to create log streams and put log events into the log group.
• Configures query logging for the hosted zone by associating it with the CloudWatch log group.
• Additionally, a CloudWatch log stream ("route53_log_stream") is created in the log group – notice that Route 53 is allowed the required permissions to create log streams if needed.

Below is the complete Terraform configuration:

<iac_template>
provider "aws" {
  region = "us-east-1"
}

resource "aws_route53_zone" "primary_zone" {
  name = "primary"
}

resource "aws_cloudwatch_log_group" "route53_log_group" {
  name = "aws_route53_example_com"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_resource_policy" "route53_policy" {
  policy_name     = "route53-query-logging-policy"
  policy_document = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid       = "Route53LogsPermissions"
        Effect    = "Allow"
        Principal = {
          Service = "route53.amazonaws.com"
        }
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${aws_cloudwatch_log_group.route53_log_group.arn}:*"
      }
    ]
  })
}

resource "aws_route53_query_log" "primary_query_log" {
  cloudwatch_log_group_arn = aws_cloudwatch_log_group.route53_log_group.arn
  zone_id                  = aws_route53_zone.primary_zone.zone_id
}

resource "aws_cloudwatch_log_stream" "route53_log_stream" {
  name           = "route53_log_stream"
  log_group_name = aws_cloudwatch_log_group.route53_log_group.name
}
</iac_template>