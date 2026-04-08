output "id" {
  description = "A combination of 'snapshot_id-account_id'"
  value       = aws_snapshot_create_volume_permission.this.id
}