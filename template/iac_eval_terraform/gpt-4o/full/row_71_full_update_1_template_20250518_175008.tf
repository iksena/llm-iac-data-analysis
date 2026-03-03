To create a basic Amazon Kinesis Analytics Application using Terraform, we will define a configuration that sets up the necessary AWS resources. This includes the Kinesis Analytics Application itself, which will process streaming data from a Kinesis Data Stream. We will also create the required IAM roles and policies to allow the application to read from the Kinesis Data Stream and write to an S3 bucket for output. The configuration will be deployed in the `us-east-1` region.

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

resource "aws_s3_bucket" "output_bucket" {
  bucket = "example-output-bucket"
  acl    = "private"
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
  description = "Policy for Kinesis Analytics to access Kinesis Stream and S3"

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
      },
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.output_bucket.arn}/*"
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