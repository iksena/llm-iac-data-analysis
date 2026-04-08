data "aws_sqs_queues" "this" {
  region            = var.region
  queue_name_prefix = var.queue_name_prefix
}