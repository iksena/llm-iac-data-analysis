provider "aws" {
  region = "us-east-1"
}

# Create IAM role for Kinesis Analytics
resource "aws_iam_role" "kinesis_analytics_role" {
  name = "kinesis_analytics_role"

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

# Create IAM policy for Kinesis Analytics
resource "aws_iam_role_policy" "kinesis_analytics_policy" {
  name = "kinesis_analytics_policy"
  role = aws_iam_role.kinesis_analytics_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kinesis:GetShardIterator",
          "kinesis:GetRecords",
          "kinesis:DescribeStream",
          "kinesis:ListShards"
        ]
        Resource = "*"
      }
    ]
  })
}

# Create Kinesis Analytics Application
resource "aws_kinesis_analytics_application" "example" {
  name = "example_kinesis_analytics_app"

  inputs {
    name_prefix = "PREFIX_SQL"

    schema_version = "1"

    kinesis_stream {
      resource_arn = "arn:aws:kinesis:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:stream/example-stream"
      role_arn     = aws_iam_role.kinesis_analytics_role.arn
    }

    schema {
      record_columns {
        name     = "example_column"
        sql_type = "VARCHAR(8)"
        mapping  = "$.example"
      }

      record_format {
        mapping_parameters {
          json {
            record_row_path = "$"
          }
        }
      }
    }
  }

  code = <<EOF
CREATE OR REPLACE STREAM "DESTINATION_SQL_STREAM" (
  example_column VARCHAR(8)
);

CREATE OR REPLACE PUMP "STREAM_PUMP" AS
  INSERT INTO "DESTINATION_SQL_STREAM"
    SELECT STREAM example_column
    FROM "PREFIX_SQL_001";
EOF
}

# Get current region
data "aws_region" "current" {}

# Get current account ID
data "aws_caller_identity" "current" {}

# Output the application name
output "kinesis_analytics_app_name" {
  value = aws_kinesis_analytics_application.example.name
}