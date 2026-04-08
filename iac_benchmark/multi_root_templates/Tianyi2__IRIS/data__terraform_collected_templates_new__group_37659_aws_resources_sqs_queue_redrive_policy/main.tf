resource "aws_sqs_queue_redrive_policy" "this" {
  region         = var.region
  queue_url      = var.queue_url
  redrive_policy = var.redrive_policy
}