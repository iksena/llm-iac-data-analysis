output "id" {
  description = "AWS Region."
  value       = data.aws_ebs_snapshot_ids.this.id
}

output "ids" {
  description = "Set of EBS snapshot IDs, sorted by creation time in descending order."
  value       = data.aws_ebs_snapshot_ids.this.ids
}