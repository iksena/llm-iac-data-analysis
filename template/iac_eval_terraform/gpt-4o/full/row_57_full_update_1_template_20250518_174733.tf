To create a basic Amazon Kinesis Analytics Application, we will define a Terraform configuration that sets up the necessary AWS resources. This includes creating an Amazon Kinesis Data Stream to serve as the input for the Kinesis Analytics Application. We will also create the Kinesis Analytics Application itself, which will be configured to read from the input stream. Additionally, we will set up the necessary IAM roles and policies to allow the Kinesis Analytics Application to access the Kinesis Data Stream.

The Terraform configuration will include:
1. An AWS provider configuration.
2. A Kinesis Data Stream to serve as the input.
3. An IAM role with the necessary permissions for the Kinesis Analytics Application.
4. A Kinesis Analytics Application configured to read from the input stream.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_kinesis_stream" "input_stream" {
  name             = "example-input-stream"
  shard_count      = 1
  retention_period = 24
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
  description = "Policy for Kinesis Analytics Application to access Kinesis Stream"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kinesis:DescribeStream",
          "kinesis:GetRecords",
          "kinesis:GetShardIterator",
          "kinesis:ListStreams"
        ]
        Effect   = "Allow"
        Resource = aws_kinesis_stream.input_stream.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.kinesis_analytics_role.name
  policy_arn = aws_iam_policy.kinesis_analytics_policy.arn
}

resource "aws_kinesis_analytics_application" "example" {
  name        = "example-analytics-app"
  description = "Example Kinesis Analytics Application"

  inputs {
    name_prefix = "example_input"

    kinesis_stream {
      resource_arn = aws_kinesis_stream.input_stream.arn
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
```
</iac_template>