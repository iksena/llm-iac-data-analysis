provider "aws" {
  region = "us-east-1"
}

# Variables
variable "app_name" {
  type    = string
  default = "example-kinesis-analytics"
}

# IAM Role
resource "aws_iam_role" "kinesis_analytics_role" {
  name = "${var.app_name}-role"

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

# IAM Policy
resource "aws_iam_role_policy" "kinesis_analytics_policy" {
  name = "${var.app_name}-policy"
  role = aws_iam_role.kinesis_analytics_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kinesis:*",
          "logs:*"
        ]
        Resource = "*"
      }
    ]
  })
}

# Kinesis Analytics Application
resource "aws_kinesisanalyticsv2_application" "example" {
  name                   = var.app_name
  runtime_environment    = "SQL-1_0"
  service_execution_role = aws_iam_role.kinesis_analytics_role.arn

  application_configuration {
    sql_application_configuration {
      input {
        name_prefix = "SQL_STREAM"
        schema_version = "1"

        input_schema {
          record_column {
            name     = "ticker_symbol"
            sql_type = "VARCHAR(4)"
            mapping  = "$.ticker_symbol"
          }
          record_column {
            name     = "price"
            sql_type = "DOUBLE"
            mapping  = "$.price"
          }
          record_column {
            name     = "transaction_time"
            sql_type = "TIMESTAMP"
            mapping  = "$.transaction_time"
          }

          record_format {
            record_format_type = "JSON"
            mapping_parameters {
              json {
                record_row_path = "$"
              }
            }
          }
        }
      }
    }

    application_code_configuration {
      code_content {
        text_content = <<-EOF
          CREATE OR REPLACE STREAM "DESTINATION_SQL_STREAM" (
            ticker_symbol VARCHAR(4),
            price DOUBLE,
            transaction_time TIMESTAMP
          );
          
          CREATE OR REPLACE PUMP "STREAM_PUMP" AS
            INSERT INTO "DESTINATION_SQL_STREAM"
            SELECT STREAM ticker_symbol, price, transaction_time
            FROM "SQL_STREAM_001";
        EOF
      }
      code_content_type = "PLAINTEXT"
    }
  }

  tags = {
    Environment = "dev"
  }
}