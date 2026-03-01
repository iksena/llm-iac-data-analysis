provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

# IAM Role for Kinesis Analytics V2
resource "aws_iam_role" "kinesisanalytics_role" {
  name = "kinesisanalytics_role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "kinesisanalytics.amazonaws.com" }
    }]
  })
}

# Inline policy for the IAM role to enable CloudWatch logging
resource "aws_iam_role_policy" "kinesisanalytics_policy" {
  name = "kinesisanalytics_policy"
  role = aws_iam_role.kinesisanalytics_role.id
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = "*"
    }]
  })
}

# Basic Kinesis Data Analytics V2 Application (SQL application)
resource "aws_kinesisanalyticsv2_application" "kinesis_sql_app" {
  name                    = "example_kinesis_sql_app"
  runtime_environment     = "SQL-1_0"
  service_execution_role  = aws_iam_role.kinesisanalytics_role.arn
  application_description = "Basic Kinesis V2 Analytics Application for SQL processing"

  application_configuration {
    sql_application_configuration {
      inputs {
        name_prefix = "example_input"

        input_schema {
          record_encoding = "UTF-8"
          
          record_columns {
            name     = "col1"
            sql_type = "VARCHAR(64)"
            mapping  = "$.col1"
          }
          
          record_format {
            record_format_type = "JSON"
            mapping_parameters {
              json_mapping_parameters {
                record_row_path = "$"
              }
            }
          }
        }

        input_parallelism {
          count = 1
        }
      }
    }
  }
}