Below is a description of the Terraform program that meets your requirements followed by the complete Terraform HCL configuration:

Description:
• The configuration uses the AWS provider (in region us-east-1) and creates a Route 53 hosted zone resource named "primary" with the domain "example.com."
• It creates an AWS CloudWatch Log Group named "aws_route53_example_com" which will be used to store Route 53 query logs.
• It defines a Route 53 query logging configuration that associates the hosted zone with the CloudWatch log group.
• It creates a CloudWatch Logs resource policy (named "route53-query-logging-policy") that authorizes the Route 53 service (i.e., route53.amazonaws.com) to create log streams and put log events into the specified log group.

Below is the complete deployable Terraform configuration:

<iac_template>
provider "aws" {
  region = "us-east-1"
}

# Create a Route 53 hosted zone named "primary"
resource "aws_route53_zone" "primary" {
  name = "example.com"
}

# Create a CloudWatch Log Group with the specified name
resource "aws_cloudwatch_log_group" "example" {
  name = "aws_route53_example_com"
  retention_in_days = 14
}

# Create a CloudWatch Logs Resource Policy that allows Route 53 to create log streams and put log events
resource "aws_cloudwatch_log_resource_policy" "route53_policy" {
  policy_name     = "route53-query-logging-policy"
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
        Resource = "${aws_cloudwatch_log_group.example.arn}:*"
      }
    ]
  })
}

# Create a Route 53 Query Logging Configuration that sends logs to the defined CloudWatch Log Group
resource "aws_route53_query_log_config" "query_logging" {
  cloudwatch_log_group_arn = aws_cloudwatch_log_group.example.arn
  # hosted_zone_id is required
  hosted_zone_id         = aws_route53_zone.primary.zone_id
}
</iac_template>