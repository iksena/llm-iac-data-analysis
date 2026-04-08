output "arn" {
  description = "Amazon Resource Name of the file system."
  value       = aws_fsx_openzfs_volume.this.arn
}

output "id" {
  description = "Identifier of the file system, e.g., fsvol-12345678."
  value       = aws_fsx_openzfs_volume.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_fsx_openzfs_volume.this.tags_all
}