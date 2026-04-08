output "id" {
  description = "The ID of the S3 bucket intelligent tiering configuration."
  value       = aws_s3_bucket_intelligent_tiering_configuration.this.id
}

output "bucket" {
  description = "The name of the bucket this intelligent tiering configuration is associated with."
  value       = aws_s3_bucket_intelligent_tiering_configuration.this.bucket
}

output "name" {
  description = "The unique name used to identify the S3 Intelligent-Tiering configuration for the bucket."
  value       = aws_s3_bucket_intelligent_tiering_configuration.this.name
}

output "status" {
  description = "The status of the configuration."
  value       = aws_s3_bucket_intelligent_tiering_configuration.this.status
}

output "region" {
  description = "The region where this resource is managed."
  value       = aws_s3_bucket_intelligent_tiering_configuration.this.region
}

output "filter" {
  description = "The bucket filter configuration."
  value       = aws_s3_bucket_intelligent_tiering_configuration.this.filter
}

output "tiering" {
  description = "The S3 Intelligent-Tiering storage class tiers configuration."
  value       = aws_s3_bucket_intelligent_tiering_configuration.this.tiering
}