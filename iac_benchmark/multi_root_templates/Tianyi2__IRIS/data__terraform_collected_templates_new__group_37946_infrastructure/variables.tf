variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "kinesis_stream_name" {
  description = "The name of the Kinesis Data Stream"
  type        = string
  default     = "BrowsingClickstream"
}

variable "dynamodb_table_one_name" {
  description = "Name of the first DynamoDB table (with Streams enabled)"
  type        = string
  default     = "BrowsingEvents"
}

variable "dynamodb_table_two_name" {
  description = "Name of the second DynamoDB table"
  type        = string
  default     = "Offers"
}

variable "glue_database_name" {
  description = "Name of the Glue database"
  type        = string
  default     = "offers_db"
}

variable "glue_crawler_name" {
  description = "Name of the Glue crawler"
  type        = string
  default     = "offers-crawler"
}

variable "glue_role_arn" {
  description = "IAM Role ARN for Glue Crawler"
  type        = string
}

variable "lambda_function_one_name" {
  description = "Name of the first Lambda function"
  type        = string
  default     = "IngestorLambda"
}

variable "lambda_function_two_name" {
  description = "Name of the second Lambda function"
  type        = string
  default     = "OfferGeneratorLambda"
}

variable "lambda_one_handler" {
  description = "Handler for the first Lambda function"
  type        = string
  default     = "IngestorLambda.handler"
}

variable "lambda_two_handler" {
  description = "Handler for the second Lambda function"
  type        = string
  default     = "OfferGeneratorLambda.handler"
}

variable "lambda_one_runtime" {
  description = "Python runtime for the first Lambda function"
  type        = string
  default     = "python3.12"
}

variable "lambda_two_runtime" {
  description = "Python runtime for the second Lambda function"
  type        = string
  default     = "python3.12"
}

variable "lambda_role_arn" {
  description = "IAM Role ARN for Lambda functions"
  type        = string
}

variable "crawler_schedule_expression" {
  description = "Cron expression for Glue Crawler schedule"
  type        = string
  default     = "cron(0/1 * * * ? *)"
}

