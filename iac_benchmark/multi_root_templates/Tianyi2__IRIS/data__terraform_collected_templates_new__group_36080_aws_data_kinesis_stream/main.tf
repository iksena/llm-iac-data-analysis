data "aws_kinesis_stream" "this" {
  name   = var.name
  region = var.region
}