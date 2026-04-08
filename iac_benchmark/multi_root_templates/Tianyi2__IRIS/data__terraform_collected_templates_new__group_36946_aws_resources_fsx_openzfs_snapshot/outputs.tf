output "arn" {
  description = "Amazon Resource Name of the snapshot."
  value       = aws_fsx_openzfs_snapshot.this.arn
}

output "id" {
  description = "Identifier of the snapshot, e.g., fsvolsnap-12345678"
  value       = aws_fsx_openzfs_snapshot.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_fsx_openzfs_snapshot.this.tags_all
}