output "arn" {
  description = "ARN of the Data Lake"
  value       = aws_securitylake_subscriber.this.arn
}

output "id" {
  description = "The Subscriber ID of the subscriber"
  value       = aws_securitylake_subscriber.this.id
}

output "s3_bucket_arn" {
  description = "The ARN for the Amazon Security Lake Amazon S3 bucket"
  value       = aws_securitylake_subscriber.this.s3_bucket_arn
}

output "resource_share_arn" {
  description = "The Amazon Resource Name (ARN) which uniquely defines the AWS RAM resource share"
  value       = aws_securitylake_subscriber.this.resource_share_arn
}

output "role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the role of the subscriber"
  value       = aws_securitylake_subscriber.this.role_arn
}

output "subscriber_endpoint" {
  description = "The subscriber endpoint to which exception messages are posted"
  value       = aws_securitylake_subscriber.this.subscriber_endpoint
}

output "subscriber_status" {
  description = "The subscriber status of the Amazon Security Lake subscriber account"
  value       = aws_securitylake_subscriber.this.subscriber_status
}

output "resource_share_name" {
  description = "The name of the resource share"
  value       = aws_securitylake_subscriber.this.resource_share_name
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_securitylake_subscriber.this.tags_all
}

output "source" {
  description = "The supported AWS services from which logs and events are collected with computed attributes"
  value       = aws_securitylake_subscriber.this.source
}