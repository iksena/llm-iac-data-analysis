output "id" {
  description = "Layer name and version number, separated by a comma (,)."
  value       = aws_lambda_layer_version_permission.this.id
}

output "policy" {
  description = "Full Lambda Layer Permission policy."
  value       = aws_lambda_layer_version_permission.this.policy
}

output "revision_id" {
  description = "Unique identifier for the current revision of the policy."
  value       = aws_lambda_layer_version_permission.this.revision_id
}