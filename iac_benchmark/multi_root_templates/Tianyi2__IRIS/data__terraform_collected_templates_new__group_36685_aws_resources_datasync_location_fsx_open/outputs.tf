output "id" {
  description = "Amazon Resource Name (ARN) of the DataSync Location."
  value       = aws_datasync_location_fsx_openzfs_file_system.this.id
}

output "arn" {
  description = "Amazon Resource Name (ARN) of the DataSync Location."
  value       = aws_datasync_location_fsx_openzfs_file_system.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_datasync_location_fsx_openzfs_file_system.this.tags_all
}

output "uri" {
  description = "The URL of the FSx for openzfs location that was described."
  value       = aws_datasync_location_fsx_openzfs_file_system.this.uri
}

output "creation_time" {
  description = "The time that the FSx for openzfs location was created."
  value       = aws_datasync_location_fsx_openzfs_file_system.this.creation_time
}