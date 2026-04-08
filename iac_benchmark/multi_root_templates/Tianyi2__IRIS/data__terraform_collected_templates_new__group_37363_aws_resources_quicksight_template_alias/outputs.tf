output "arn" {
  description = "Amazon Resource Name (ARN) of the template alias."
  value       = aws_quicksight_template_alias.this.arn
}

output "id" {
  description = "A comma-delimited string joining AWS account ID, template ID, and alias name."
  value       = aws_quicksight_template_alias.this.id
}

output "alias_name" {
  description = "Display name of the template alias."
  value       = aws_quicksight_template_alias.this.alias_name
}

output "template_id" {
  description = "ID of the template."
  value       = aws_quicksight_template_alias.this.template_id
}

output "template_version_number" {
  description = "Version number of the template."
  value       = aws_quicksight_template_alias.this.template_version_number
}

output "aws_account_id" {
  description = "AWS account ID."
  value       = aws_quicksight_template_alias.this.aws_account_id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_quicksight_template_alias.this.region
}