data "aws_kinesis_firehose_delivery_stream" "this" {
  name   = var.name
  region = var.region
}