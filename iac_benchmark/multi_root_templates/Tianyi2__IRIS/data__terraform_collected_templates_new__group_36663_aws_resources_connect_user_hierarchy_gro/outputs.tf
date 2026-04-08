output "arn" {
  description = "The Amazon Resource Name (ARN) of the hierarchy group."
  value       = aws_connect_user_hierarchy_group.this.arn
}

output "hierarchy_group_id" {
  description = "The identifier for the hierarchy group."
  value       = aws_connect_user_hierarchy_group.this.hierarchy_group_id
}

output "hierarchy_path" {
  description = "A block that contains information about the levels in the hierarchy group."
  value       = aws_connect_user_hierarchy_group.this.hierarchy_path
}

output "id" {
  description = "The identifier of the hosting Amazon Connect Instance and identifier of the hierarchy group separated by a colon (:)."
  value       = aws_connect_user_hierarchy_group.this.id
}

output "level_id" {
  description = "The identifier of the level in the hierarchy group."
  value       = aws_connect_user_hierarchy_group.this.level_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_connect_user_hierarchy_group.this.tags_all
}