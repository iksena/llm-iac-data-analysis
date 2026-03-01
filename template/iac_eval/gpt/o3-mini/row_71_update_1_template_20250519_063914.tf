provider "aws" {
  region = "us-east-1"
}

# Create a basic Kinesis data stream to serve as input for the analytics application.
resource "aws_kinesis_stream" "input_stream" {
  name             = "example-stream"
  shard_count      = 1
  retention_period = 24
}

# Create an IAM role for the Kinesis Analytics Application with a trust policy.
resource "aws_iam_role" "kinesis_analytics_role" {
  name = "kinesis-analytics-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "kinesisanalytics.amazonaws.com"
        }
      }
    ]
  })
}

# Attach an inline policy to allow necessary Kinesis actions on the input stream.
resource "aws_iam_role_policy" "kinesis_analytics_policy" {
  name   = "kinesis-analytics-policy"
  role   = aws_iam_role.kinesis_analytics_role.id

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "kinesis:DescribeStream",
          "kinesis:GetShardIterator",
          "kinesis:GetRecords"
        ]
        Resource = aws_kinesis_stream.input_stream.arn
      }
    ]
  })
}

# Define the basic Kinesis Analytics Application.
resource "aws_kinesis_analytics_application" "example" {
  name        = "example-kinesis-analytics"
  description = "A basic Kinesis Analytics Application reading from a Kinesis stream."

  # SQL code for the application
  code = <<EOF
-- Create a destination stream and define a pump to move data.
CREATE OR REPLACE STREAM "DESTINATION_SQL_STREAM" (message VARCHAR(64));
CREATE OR REPLACE PUMP "STREAM_PUMP" AS INSERT INTO "DESTINATION_SQL_STREAM"
SELECT STREAM message FROM "ExampleInput";
EOF

  inputs {
    name_prefix = "ExampleInput"

    kinesis_stream {
      resource_arn = aws_kinesis_stream.input_stream.arn
      role_arn     = aws_iam_role.kinesis_analytics_role.arn
    }

    # Define how incoming data is expected to be structured.
    input_schema {
      record_format {
        record_format_type = "JSON"
        mapping_parameters {
          json_mapping_parameters {
            record_row_path = "$"
          }
        }
      }

      record_columns {
        name    = "message"
        sql_type = "VARCHAR(64)"
        mapping  = "$.message"
      }
    }

    parallelism {
      count = 1
    }
  }
}