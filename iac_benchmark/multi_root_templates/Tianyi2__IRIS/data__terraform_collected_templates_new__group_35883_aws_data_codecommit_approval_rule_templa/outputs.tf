output "approval_rule_template_id" {
  description = "The ID of the approval rule template."
  value       = data.aws_codecommit_approval_rule_template.this.approval_rule_template_id
}

output "content" {
  description = "Content of the approval rule template."
  value       = data.aws_codecommit_approval_rule_template.this.content
}

output "creation_date" {
  description = "Date the approval rule template was created, in RFC3339 format."
  value       = data.aws_codecommit_approval_rule_template.this.creation_date
}

output "description" {
  description = "Description of the approval rule template."
  value       = data.aws_codecommit_approval_rule_template.this.description
}

output "last_modified_date" {
  description = "Date the approval rule template was most recently changed, in RFC3339 format."
  value       = data.aws_codecommit_approval_rule_template.this.last_modified_date
}

output "last_modified_user" {
  description = "ARN of the user who made the most recent changes to the approval rule template."
  value       = data.aws_codecommit_approval_rule_template.this.last_modified_user
}

output "rule_content_sha256" {
  description = "SHA-256 hash signature for the content of the approval rule template."
  value       = data.aws_codecommit_approval_rule_template.this.rule_content_sha256
}

output "name" {
  description = "Name for the approval rule template."
  value       = data.aws_codecommit_approval_rule_template.this.name
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_codecommit_approval_rule_template.this.region
}