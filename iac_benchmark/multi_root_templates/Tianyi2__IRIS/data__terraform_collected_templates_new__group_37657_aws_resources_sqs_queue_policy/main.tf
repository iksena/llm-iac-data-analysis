resource "aws_sqs_queue_policy" "this" {
  region    = var.region
  policy    = var.policy
  queue_url = var.queue_url
}