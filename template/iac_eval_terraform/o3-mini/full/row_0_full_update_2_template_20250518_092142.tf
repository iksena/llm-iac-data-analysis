Below is a description of what the Terraform program will do:

1. It configures the AWS provider in the us-east-1 region.
2. It creates a Route 53 hosted zone resource named "primary". (Note that while the resource block is named "primary", its name attribute is set to "primary", per the business specification.)
3. It creates a CloudWatch Log Group with the name "aws_route53_example_com" and sets a retention period.
4. It creates a CloudWatch Log Resource Policy named "route53-query-logging-policy" that allows the Route 53 service to create log streams and put log events in the specified log group.
5. It creates a Route 53 Query Logging Configuration that associates the hosted zone with the CloudWatch log group.

Below is the complete deployable Terraform HCL template:

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

# Create a Route 53 Query Logging Configuration that sends logs to the defined CloudWatch Log Group
resource "aws_route53_query_log_config" "query_logging" {
  cloudwatch_log_group_arn = aws_cloudwatch_log_group.example.arn
  hosted_zone_id           = aws_route53_zone.primary.zone_id
}
</iac_template>