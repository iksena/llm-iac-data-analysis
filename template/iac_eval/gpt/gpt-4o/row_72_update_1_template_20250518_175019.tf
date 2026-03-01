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
  description = "Policy for Kinesis Analytics to access streams"

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
        Resource = "*"
      },
      {
        Action = [
          "firehose:PutRecord",
          "firehose:PutRecordBatch"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "kinesis_analytics_policy_attach" {
  role       = aws_iam_role.kinesis_analytics_role.name
  policy_arn = aws_iam_policy.kinesis_analytics_policy.arn
}

resource "aws_kinesis_analyticsv2_application" "sql_application" {
  name        = "MyKinesisSQLApp"
  runtime_environment = "SQL-1_0"
  service_execution_role = aws_iam_role.kinesis_analytics_role.arn

  application_configuration {
    sql_application_configuration {
      inputs {
        name_prefix = "exampleStream"

        kinesis_streams_input {
          resource_arn = "arn:aws:kinesis:us-east-1:123456789012:stream/exampleStream"
        }

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
            name    = "exampleColumn"
            mapping = "$.exampleColumn"
            sql_type = "VARCHAR(16)"
          }
        }
      }
    }
  }
}