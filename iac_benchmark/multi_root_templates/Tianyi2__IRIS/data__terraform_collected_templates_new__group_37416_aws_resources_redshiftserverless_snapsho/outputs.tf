output "accounts_with_provisioned_restore_access" {
  description = "All of the Amazon Web Services accounts that have access to restore a snapshot to a provisioned cluster."
  value       = aws_redshiftserverless_snapshot.this.accounts_with_provisioned_restore_access
}

output "accounts_with_restore_access" {
  description = "All of the Amazon Web Services accounts that have access to restore a snapshot to a namespace."
  value       = aws_redshiftserverless_snapshot.this.accounts_with_restore_access
}

output "admin_username" {
  description = "The username of the database within a snapshot."
  value       = aws_redshiftserverless_snapshot.this.admin_username
}

output "arn" {
  description = "The Amazon Resource Name (ARN) of the snapshot."
  value       = aws_redshiftserverless_snapshot.this.arn
}

output "id" {
  description = "The name of the snapshot."
  value       = aws_redshiftserverless_snapshot.this.id
}

output "kms_key_id" {
  description = "The unique identifier of the KMS key used to encrypt the snapshot."
  value       = aws_redshiftserverless_snapshot.this.kms_key_id
}

output "namespace_arn" {
  description = "The Amazon Resource Name (ARN) of the namespace the snapshot was created from."
  value       = aws_redshiftserverless_snapshot.this.namespace_arn
}

output "owner_account" {
  description = "The owner Amazon Web Services account of the snapshot."
  value       = aws_redshiftserverless_snapshot.this.owner_account
}