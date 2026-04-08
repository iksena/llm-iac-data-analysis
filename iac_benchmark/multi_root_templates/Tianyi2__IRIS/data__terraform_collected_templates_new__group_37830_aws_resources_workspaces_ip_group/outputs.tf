output "id" {
  description = "The IP group identifier"
  value       = aws_workspaces_ip_group.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_workspaces_ip_group.this.tags_all
}