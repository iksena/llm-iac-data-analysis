output "arns" {
  description = "Set of Amazon Resource Names (ARNs) of the SSO Instances."
  value       = data.aws_ssoadmin_instances.this.arns
}

output "id" {
  description = "AWS Region."
  value       = data.aws_ssoadmin_instances.this.id
}

output "identity_store_ids" {
  description = "Set of identifiers of the identity stores connected to the SSO Instances."
  value       = data.aws_ssoadmin_instances.this.identity_store_ids
}