output "arns" {
  description = "Set of Amazon Resource Names (ARNs)."
  value       = data.aws_efs_access_points.this.arns
}

output "id" {
  description = "EFS File System identifier."
  value       = data.aws_efs_access_points.this.id
}

output "ids" {
  description = "Set of identifiers."
  value       = data.aws_efs_access_points.this.ids
}