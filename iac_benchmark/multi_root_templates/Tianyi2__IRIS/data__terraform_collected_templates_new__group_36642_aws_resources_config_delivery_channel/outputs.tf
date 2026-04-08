output "id" {
  description = "The name of the delivery channel."
  value       = aws_config_delivery_channel.this.id
}

output "name" {
  description = "The name of the delivery channel."
  value       = aws_config_delivery_channel.this.name
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket used to store the configuration history."
  value       = aws_config_delivery_channel.this.s3_bucket_name
}

output "s3_key_prefix" {
  description = "The prefix for the specified S3 bucket."
  value       = aws_config_delivery_channel.this.s3_key_prefix
}

output "s3_kms_key_arn" {
  description = "The ARN of the AWS KMS key used to encrypt objects delivered by AWS Config."
  value       = aws_config_delivery_channel.this.s3_kms_key_arn
}

output "sns_topic_arn" {
  description = "The ARN of the SNS topic that AWS Config delivers notifications to."
  value       = aws_config_delivery_channel.this.sns_topic_arn
}

output "snapshot_delivery_properties" {
  description = "Options for how AWS Config delivers configuration snapshots."
  value       = aws_config_delivery_channel.this.snapshot_delivery_properties
}