output "arn" {
  description = "Amazon Resource Name (ARN) of the S3 Storage Lens configuration."
  value       = aws_s3control_storage_lens_configuration.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_s3control_storage_lens_configuration.this.tags_all
}