output "id" {
  description = "AWS region."
  value       = aws_ebs_snapshot_block_public_access.this.id
}

output "region" {
  description = "Region where the resource is managed."
  value       = aws_ebs_snapshot_block_public_access.this.region
}

output "state" {
  description = "The mode in which 'Block public access for snapshots' is enabled for the region."
  value       = aws_ebs_snapshot_block_public_access.this.state
}