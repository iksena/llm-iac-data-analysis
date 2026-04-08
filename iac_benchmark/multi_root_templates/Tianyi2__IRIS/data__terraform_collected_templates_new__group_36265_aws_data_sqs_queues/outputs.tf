output "queue_urls" {
  description = "A list of queue URLs"
  value       = data.aws_sqs_queues.this.queue_urls
}