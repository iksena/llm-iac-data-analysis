data "aws_sqs_queue" "this" {
  name   = var.name
  region = var.region
}