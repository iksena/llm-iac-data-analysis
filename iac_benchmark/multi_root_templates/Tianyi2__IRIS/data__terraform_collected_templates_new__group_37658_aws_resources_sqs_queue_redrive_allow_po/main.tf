resource "aws_sqs_queue_redrive_allow_policy" "this" {
  region               = var.region
  queue_url            = var.queue_url
  redrive_allow_policy = var.redrive_allow_policy
}