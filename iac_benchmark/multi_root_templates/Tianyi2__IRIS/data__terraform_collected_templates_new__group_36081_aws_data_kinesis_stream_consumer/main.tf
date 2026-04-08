data "aws_kinesis_stream_consumer" "this" {
  region     = var.region
  arn        = var.arn
  name       = var.name
  stream_arn = var.stream_arn
}