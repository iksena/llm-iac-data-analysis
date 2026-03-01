Below is an improved Terraform configuration that uses the proper AWS resource for configuring Route 53 query logging. In this version the resource "aws_route53_query_logging_config" is used (with the correct attribute "zone_id" instead of "hosted_zone_id") and the log group's ARN is properly formatted for the policy document.

<iac_template>
provider "aws" {
  region = "us-east-1"
}

# Create a Route 53 hosted zone named "primary"
resource "aws_route53_zone" "primary" {
  name = "primary"
}

# Create a CloudWatch Log Group with the specified name
resource "aws_cloudwatch_log_group" "example" {
  name              = "aws_route53_example_com"
  retention_in_days = 14
}

# Create a CloudWatch Logs Resource Policy that allows Route 53 to create log streams and put log events
resource "aws_cloudwatch_log_resource_policy" "route53_policy" {
  policy_name = "route53-query-logging-policy"
  policy_document = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Sid       = "Route53QueryLoggingPolicy",
        Effect    = "Allow",
        Principal = {
          Service = "route53.amazonaws.com"
        },
        Action   = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = format("%s:*", aws_cloudwatch_log_group.example.arn)
      }
    ]
  })
}

# Create the Route 53 Query Logging Configuration that sends logs to the specified CloudWatch Log Group
resource "aws_route53_query_logging_config" "query_logging" {
  cloudwatch_log_group_arn = aws_cloudwatch_log_group.example.arn
  zone_id                  = aws_route53_zone.primary.zone_id
}
</iac_template>