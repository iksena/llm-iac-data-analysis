output "admin_username" {
  description = "The username of the administrator for the first database created in the namespace."
  value       = data.aws_redshiftserverless_namespace.this.admin_username
}

output "arn" {
  description = "Amazon Resource Name (ARN) of the Redshift Serverless Namespace."
  value       = data.aws_redshiftserverless_namespace.this.arn
}

output "db_name" {
  description = "The name of the first database created in the namespace."
  value       = data.aws_redshiftserverless_namespace.this.db_name
}

output "default_iam_role_arn" {
  description = "The Amazon Resource Name (ARN) of the IAM role to set as a default in the namespace."
  value       = data.aws_redshiftserverless_namespace.this.default_iam_role_arn
}

output "iam_roles" {
  description = "A list of IAM roles to associate with the namespace."
  value       = data.aws_redshiftserverless_namespace.this.iam_roles
}

output "kms_key_id" {
  description = "The ARN of the Amazon Web Services Key Management Service key used to encrypt your data."
  value       = data.aws_redshiftserverless_namespace.this.kms_key_id
}

output "log_exports" {
  description = "The types of logs the namespace can export. Available export types are userlog, connectionlog, and useractivitylog."
  value       = data.aws_redshiftserverless_namespace.this.log_exports
}

output "namespace_id" {
  description = "The Redshift Namespace ID."
  value       = data.aws_redshiftserverless_namespace.this.namespace_id
}

output "namespace_name" {
  description = "The name of the namespace."
  value       = data.aws_redshiftserverless_namespace.this.namespace_name
}

output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_redshiftserverless_namespace.this.region
}