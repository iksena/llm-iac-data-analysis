output "id" {
  description = "A comma-delimited string concatenating availability_zone and snapshot_id."
  value       = aws_ebs_fast_snapshot_restore.this.id
}

output "state" {
  description = "State of fast snapshot restores. Valid values are enabling, optimizing, enabled, disabling, disabled."
  value       = aws_ebs_fast_snapshot_restore.this.state
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_ebs_fast_snapshot_restore.this.region
}

output "availability_zone" {
  description = "Availability zone in which fast snapshot restores are enabled."
  value       = aws_ebs_fast_snapshot_restore.this.availability_zone
}

output "snapshot_id" {
  description = "ID of the snapshot."
  value       = aws_ebs_fast_snapshot_restore.this.snapshot_id
}