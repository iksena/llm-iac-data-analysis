output "admin_password_secret_arn" {
  description = "Amazon Resource Name (ARN) of namespace's admin user credentials secret."
  value       = aws_redshiftserverless_namespace.this.admin_password_secret_arn
}

output "arn" {
  description = "Amazon Resource Name (ARN) of the Redshift Serverless Namespace."
  value       = aws_redshiftserverless_namespace.this.arn
}

output "id" {
  description = "The Redshift Namespace Name."
  value       = aws_redshiftserverless_namespace.this.id
}

output "namespace_id" {
  description = "The Redshift Namespace ID."
  value       = aws_redshiftserverless_namespace.this.namespace_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_redshiftserverless_namespace.this.tags_all
}