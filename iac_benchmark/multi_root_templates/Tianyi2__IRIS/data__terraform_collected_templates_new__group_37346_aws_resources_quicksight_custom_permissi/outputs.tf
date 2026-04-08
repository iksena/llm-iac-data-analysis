output "arn" {
  description = "ARN of the custom permissions profile."
  value       = aws_quicksight_custom_permissions.this.arn
}

output "aws_account_id" {
  description = "AWS account ID."
  value       = aws_quicksight_custom_permissions.this.aws_account_id
}

output "custom_permissions_name" {
  description = "Custom permissions profile name."
  value       = aws_quicksight_custom_permissions.this.custom_permissions_name
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_quicksight_custom_permissions.this.region
}

output "tags" {
  description = "Key-value map of resource tags."
  value       = aws_quicksight_custom_permissions.this.tags
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_quicksight_custom_permissions.this.tags_all
}

output "capabilities" {
  description = "Actions included in the custom permissions profile."
  value       = aws_quicksight_custom_permissions.this.capabilities
}