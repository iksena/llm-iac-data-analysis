output "arn" {
  description = "The ARN assigned by AWS for this resource group."
  value       = aws_resourcegroups_group.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_resourcegroups_group.this.tags_all
}