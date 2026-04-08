output "arn" {
  description = "ARN of the Data Lake."
  value       = aws_securitylake_data_lake.this.arn
}

output "s3_bucket_arn" {
  description = "The ARN for the Amazon Security Lake Amazon S3 bucket."
  value       = aws_securitylake_data_lake.this.s3_bucket_arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_securitylake_data_lake.this.tags_all
}