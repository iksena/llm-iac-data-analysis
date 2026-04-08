output "tags" {
  description = "Map of key=value pairs for each tag set on the resource."
  value       = data.aws_organizations_resource_tags.this.tags
}