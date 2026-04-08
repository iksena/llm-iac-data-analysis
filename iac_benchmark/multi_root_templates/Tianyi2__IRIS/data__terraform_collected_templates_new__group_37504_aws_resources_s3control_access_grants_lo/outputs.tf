output "access_grants_location_arn" {
  description = "Amazon Resource Name (ARN) of the S3 Access Grants location."
  value       = aws_s3control_access_grants_location.this.access_grants_location_arn
}

output "access_grants_location_id" {
  description = "Unique ID of the S3 Access Grants location."
  value       = aws_s3control_access_grants_location.this.access_grants_location_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_s3control_access_grants_location.this.tags_all
}