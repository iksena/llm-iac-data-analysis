resource "aws_dynamodb_kinesis_streaming_destination" "this" {
  region                                   = var.region
  approximate_creation_date_time_precision = var.approximate_creation_date_time_precision
  stream_arn                               = var.stream_arn
  table_name                               = var.table_name
}