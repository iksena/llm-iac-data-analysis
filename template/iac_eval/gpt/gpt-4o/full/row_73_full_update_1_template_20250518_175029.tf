To fulfill the business need, we will create a Terraform configuration that sets up an Amazon Kinesis Data Analytics application. This application will process streaming data. Additionally, we will configure a CloudWatch log group and log stream to capture logs from the Kinesis Analytics application for monitoring and troubleshooting purposes. We will also create the necessary IAM roles and policies to allow the Kinesis Analytics application to access the required AWS resources.

The Terraform configuration will include:
1. AWS provider configuration.
2. An IAM role with the necessary permissions for the Kinesis Analytics application.
3. A Kinesis Data Analytics application.
4. A CloudWatch log group and log stream for logging.

Here is the Terraform HCL configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "kinesis_analytics_role" {
  name = "KinesisAnalyticsRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "kinesisanalytics.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "kinesis_analytics_policy" {
  name        = "KinesisAnalyticsPolicy"
  description = "Policy for Kinesis Analytics Application"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kinesis:DescribeStream",
          "kinesis:GetRecords",
          "kinesis:GetShardIterator",
          "kinesis:ListStreams",
          "kinesis:ListShards"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "kinesis_analytics_policy_attachment" {
  role       = aws_iam_role.kinesis_analytics_role.name
  policy_arn = aws_iam_policy.kinesis_analytics_policy.arn
}

resource "aws_kinesis_analytics_application" "example" {
  name        = "example-kinesis-analytics-app"
  description = "Example Kinesis Analytics Application"
  inputs {
    name_prefix = "example"
    kinesis_stream {
      resource_arn = "arn:aws:kinesis:us-east-1:123456789012:stream/example-stream"
      role_arn     = aws_iam_role.kinesis_analytics_role.arn
    }
    schema {
      record_format_type = "JSON"
      record_columns {
        name    = "example_column"
        mapping = "$.example"
        sql_type = "VARCHAR(64)"
      }
    }
  }
}

resource "aws_cloudwatch_log_group" "kinesis_analytics_log_group" {
  name = "/aws/kinesis-analytics/example"
}

resource "aws_cloudwatch_log_stream" "kinesis_analytics_log_stream" {
  name           = "example-log-stream"
  log_group_name = aws_cloudwatch_log_group.kinesis_analytics_log_group.name
}
```
</iac_template>

This configuration sets up a basic Kinesis Analytics application with logging enabled through CloudWatch. The IAM role and policy ensure that the application has the necessary permissions to access Kinesis streams and log events to CloudWatch.