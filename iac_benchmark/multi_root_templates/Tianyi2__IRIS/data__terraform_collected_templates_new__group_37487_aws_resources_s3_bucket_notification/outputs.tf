output "id" {
  description = "The ID of the S3 bucket notification"
  value       = aws_s3_bucket_notification.this.id
}

output "bucket" {
  description = "The name of the bucket"
  value       = aws_s3_bucket_notification.this.bucket
}

output "region" {
  description = "The region where the resource is managed"
  value       = aws_s3_bucket_notification.this.region
}

output "eventbridge" {
  description = "Whether Amazon EventBridge notifications are enabled"
  value       = aws_s3_bucket_notification.this.eventbridge
}

output "lambda_function" {
  description = "Lambda function notification configurations"
  value       = aws_s3_bucket_notification.this.lambda_function
}

output "queue" {
  description = "SQS queue notification configurations"
  value       = aws_s3_bucket_notification.this.queue
}

output "topic" {
  description = "SNS topic notification configurations"
  value       = aws_s3_bucket_notification.this.topic
}