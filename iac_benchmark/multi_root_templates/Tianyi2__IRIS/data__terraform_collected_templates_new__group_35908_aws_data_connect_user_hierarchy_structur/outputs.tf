output "hierarchy_structure" {
  description = "Block that defines the hierarchy structure's levels"
  value       = data.aws_connect_user_hierarchy_structure.this.hierarchy_structure
}

output "level_one" {
  description = "Details of level one hierarchy"
  value       = try(data.aws_connect_user_hierarchy_structure.this.hierarchy_structure[0].level_one, null)
}

output "level_two" {
  description = "Details of level two hierarchy"
  value       = try(data.aws_connect_user_hierarchy_structure.this.hierarchy_structure[0].level_two, null)
}

output "level_three" {
  description = "Details of level three hierarchy"
  value       = try(data.aws_connect_user_hierarchy_structure.this.hierarchy_structure[0].level_three, null)
}

output "level_four" {
  description = "Details of level four hierarchy"
  value       = try(data.aws_connect_user_hierarchy_structure.this.hierarchy_structure[0].level_four, null)
}

output "level_five" {
  description = "Details of level five hierarchy"
  value       = try(data.aws_connect_user_hierarchy_structure.this.hierarchy_structure[0].level_five, null)
}

output "level_one_arn" {
  description = "ARN of the level one hierarchy"
  value       = try(data.aws_connect_user_hierarchy_structure.this.hierarchy_structure[0].level_one[0].arn, null)
}

output "level_one_id" {
  description = "Identifier of the level one hierarchy"
  value       = try(data.aws_connect_user_hierarchy_structure.this.hierarchy_structure[0].level_one[0].id, null)
}

output "level_one_name" {
  description = "Name of the level one hierarchy"
  value       = try(data.aws_connect_user_hierarchy_structure.this.hierarchy_structure[0].level_one[0].name, null)
}

output "level_two_arn" {
  description = "ARN of the level two hierarchy"
  value       = try(data.aws_connect_user_hierarchy_structure.this.hierarchy_structure[0].level_two[0].arn, null)
}

output "level_two_id" {
  description = "Identifier of the level two hierarchy"
  value       = try(data.aws_connect_user_hierarchy_structure.this.hierarchy_structure[0].level_two[0].id, null)
}

output "level_two_name" {
  description = "Name of the level two hierarchy"
  value       = try(data.aws_connect_user_hierarchy_structure.this.hierarchy_structure[0].level_two[0].name, null)
}

output "level_three_arn" {
  description = "ARN of the level three hierarchy"
  value       = try(data.aws_connect_user_hierarchy_structure.this.hierarchy_structure[0].level_three[0].arn, null)
}

output "level_three_id" {
  description = "Identifier of the level three hierarchy"
  value       = try(data.aws_connect_user_hierarchy_structure.this.hierarchy_structure[0].level_three[0].id, null)
}

output "level_three_name" {
  description = "Name of the level three hierarchy"
  value       = try(data.aws_connect_user_hierarchy_structure.this.hierarchy_structure[0].level_three[0].name, null)
}

output "level_four_arn" {
  description = "ARN of the level four hierarchy"
  value       = try(data.aws_connect_user_hierarchy_structure.this.hierarchy_structure[0].level_four[0].arn, null)
}

output "level_four_id" {
  description = "Identifier of the level four hierarchy"
  value       = try(data.aws_connect_user_hierarchy_structure.this.hierarchy_structure[0].level_four[0].id, null)
}

output "level_four_name" {
  description = "Name of the level four hierarchy"
  value       = try(data.aws_connect_user_hierarchy_structure.this.hierarchy_structure[0].level_four[0].name, null)
}

output "level_five_arn" {
  description = "ARN of the level five hierarchy"
  value       = try(data.aws_connect_user_hierarchy_structure.this.hierarchy_structure[0].level_five[0].arn, null)
}

output "level_five_id" {
  description = "Identifier of the level five hierarchy"
  value       = try(data.aws_connect_user_hierarchy_structure.this.hierarchy_structure[0].level_five[0].id, null)
}

output "level_five_name" {
  description = "Name of the level five hierarchy"
  value       = try(data.aws_connect_user_hierarchy_structure.this.hierarchy_structure[0].level_five[0].name, null)
}