output "arns" {
  description = "Set of ARNs of the matched Secrets Manager secrets"
  value       = data.aws_secretsmanager_secrets.this.arns
}

output "names" {
  description = "Set of names of the matched Secrets Manager secrets"
  value       = data.aws_secretsmanager_secrets.this.names
}