output "arn" {
  description = "Amazon Resource Name (ARN) of the DataSync Location."
  value       = aws_datasync_location_object_storage.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_datasync_location_object_storage.this.tags_all
}

output "uri" {
  description = "The URL of the Object Storage location that was described."
  value       = aws_datasync_location_object_storage.this.uri
}