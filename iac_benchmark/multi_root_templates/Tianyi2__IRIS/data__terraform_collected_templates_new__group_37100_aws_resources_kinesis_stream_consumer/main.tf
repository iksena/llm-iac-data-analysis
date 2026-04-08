resource "aws_kinesis_stream_consumer" "this" {
  region     = var.region
  name       = var.name
  stream_arn = var.stream_arn
}