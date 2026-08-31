locals {
  tags = {
    Project     = var.project
    ProjectId   = var.project_id
    Environment = var.env
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "archive_file" "start_lambda" {
  type        = "zip"
  source_file = "./src/start_lambda_function.py"
  output_path = "./src/lambda_function_start.zip"
}

data "archive_file" "stop_lambda" {
  type        = "zip"
  source_file = "./src/stop_lambda_function.py"
  output_path = "./src/lambda_function_stop.zip"
}
