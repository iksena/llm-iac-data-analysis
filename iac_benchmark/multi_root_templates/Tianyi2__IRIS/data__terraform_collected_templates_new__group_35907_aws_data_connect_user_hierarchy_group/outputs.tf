output "arn" {
  description = "ARN of the hierarchy group"
  value       = data.aws_connect_user_hierarchy_group.this.arn
}

output "hierarchy_path" {
  description = "Block that contains information about the levels in the hierarchy group"
  value       = data.aws_connect_user_hierarchy_group.this.hierarchy_path
}

output "level_id" {
  description = "Identifier of the level in the hierarchy group"
  value       = data.aws_connect_user_hierarchy_group.this.level_id
}

output "id" {
  description = "Identifier of the hosting Amazon Connect Instance and identifier of the hierarchy group separated by a colon"
  value       = data.aws_connect_user_hierarchy_group.this.id
}

output "tags" {
  description = "Map of tags to assign to the hierarchy group"
  value       = data.aws_connect_user_hierarchy_group.this.tags
}

output "hierarchy_path_level_one" {
  description = "Details of level one in hierarchy path"
  value       = try(data.aws_connect_user_hierarchy_group.this.hierarchy_path[0].level_one, null)
}

output "hierarchy_path_level_two" {
  description = "Details of level two in hierarchy path"
  value       = try(data.aws_connect_user_hierarchy_group.this.hierarchy_path[0].level_two, null)
}

output "hierarchy_path_level_three" {
  description = "Details of level three in hierarchy path"
  value       = try(data.aws_connect_user_hierarchy_group.this.hierarchy_path[0].level_three, null)
}

output "hierarchy_path_level_four" {
  description = "Details of level four in hierarchy path"
  value       = try(data.aws_connect_user_hierarchy_group.this.hierarchy_path[0].level_four, null)
}

output "hierarchy_path_level_five" {
  description = "Details of level five in hierarchy path"
  value       = try(data.aws_connect_user_hierarchy_group.this.hierarchy_path[0].level_five, null)
}