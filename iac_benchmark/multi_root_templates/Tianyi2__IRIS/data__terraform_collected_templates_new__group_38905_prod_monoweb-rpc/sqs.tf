resource "aws_sqs_queue" "email_delivery" {
  name       = "monoweb-prd-rpc-email-delivery"
  fifo_queue = false

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.email_deliver_dlq.arn
    // AWS SQS will attempt to deliver the message 3 times before sending it to the DLQ
    maxReceiveCount = 3
  })

  # Retain messages for up to 1 day in case we break production or something?
  message_retention_seconds = 86400
}

resource "aws_sqs_queue" "email_deliver_dlq" {
  name       = "monoweb-prd-rpc-email-delivery-dlq"
  fifo_queue = false

  # Allow up to 14 days for Dotkom to investigate issues with email delivery
  message_retention_seconds = 1209600
}
