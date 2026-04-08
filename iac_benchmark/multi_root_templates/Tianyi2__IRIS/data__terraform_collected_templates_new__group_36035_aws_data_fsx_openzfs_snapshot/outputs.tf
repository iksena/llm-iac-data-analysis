output "arn" {
  description = "Amazon Resource Name of the snapshot."
  value       = data.aws_fsx_openzfs_snapshot.this.arn
}

output "creation_time" {
  description = "Time that the resource was created."
  value       = data.aws_fsx_openzfs_snapshot.this.creation_time
}

output "id" {
  description = "Identifier of the snapshot, e.g., fsvolsnap-12345678"
  value       = data.aws_fsx_openzfs_snapshot.this.id
}

output "name" {
  description = "Name of the snapshot."
  value       = data.aws_fsx_openzfs_snapshot.this.name
}

output "snapshot_id" {
  description = "ID of the snapshot."
  value       = data.aws_fsx_openzfs_snapshot.this.snapshot_id
}

output "tags" {
  description = "List of Tag values, with a maximum of 50 elements."
  value       = data.aws_fsx_openzfs_snapshot.this.tags
}

output "volume_id" {
  description = "ID of the volume that the snapshot is of."
  value       = data.aws_fsx_openzfs_snapshot.this.volume_id
}