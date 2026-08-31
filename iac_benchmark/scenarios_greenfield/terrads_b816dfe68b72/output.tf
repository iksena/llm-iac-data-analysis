output "accessKey" {
  value = aws_iam_access_key.access-key.id
}

output "secretKey" {
  value     = aws_iam_access_key.access-key.secret
  sensitive = true
}

output "sqsURL" {
  value = aws_sqs_queue.sqs-queue.url
}