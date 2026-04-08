output "id" {
  description = "Amazon Resource Name (ARN) of the DataSync Location."
  value       = aws_datasync_location_efs.this.id
}

output "arn" {
  description = "Amazon Resource Name (ARN) of the DataSync Location."
  value       = aws_datasync_location_efs.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_datasync_location_efs.this.tags_all
}