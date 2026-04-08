output "access_grant_arn" {
  description = "Amazon Resource Name (ARN) of the S3 Access Grant"
  value       = aws_s3control_access_grant.this.access_grant_arn
}

output "access_grant_id" {
  description = "Unique ID of the S3 Access Grant"
  value       = aws_s3control_access_grant.this.access_grant_id
}

output "grant_scope" {
  description = "The access grant's scope"
  value       = aws_s3control_access_grant.this.grant_scope
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_s3control_access_grant.this.tags_all
}