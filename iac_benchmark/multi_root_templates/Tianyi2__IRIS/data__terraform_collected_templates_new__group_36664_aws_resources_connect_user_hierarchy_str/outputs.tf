output "id" {
  description = "The identifier of the hosting Amazon Connect Instance."
  value       = aws_connect_user_hierarchy_structure.this.id
}

output "hierarchy_structure" {
  description = "The hierarchy structure with additional attributes (arn and id) for each level."
  value       = aws_connect_user_hierarchy_structure.this.hierarchy_structure
}