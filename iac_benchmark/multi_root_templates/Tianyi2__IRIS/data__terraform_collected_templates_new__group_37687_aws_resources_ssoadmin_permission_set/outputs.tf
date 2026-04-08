output "arn" {
  description = "The Amazon Resource Name (ARN) of the Permission Set."
  value       = aws_ssoadmin_permission_set.this.arn
}

output "id" {
  description = "The Amazon Resource Names (ARNs) of the Permission Set and SSO Instance, separated by a comma (`,`)."
  value       = aws_ssoadmin_permission_set.this.id
}

output "created_date" {
  description = "The date the Permission Set was created in RFC3339 format."
  value       = aws_ssoadmin_permission_set.this.created_date
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ssoadmin_permission_set.this.tags_all
}