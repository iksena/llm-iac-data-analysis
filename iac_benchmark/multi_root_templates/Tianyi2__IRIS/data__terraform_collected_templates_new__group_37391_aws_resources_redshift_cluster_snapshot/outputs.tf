output "arn" {
  description = "Amazon Resource Name (ARN) of the snapshot."
  value       = aws_redshift_cluster_snapshot.this.arn
}

output "id" {
  description = "A unique identifier for the snapshot that you are requesting. This identifier must be unique for all snapshots within the Amazon Web Services account."
  value       = aws_redshift_cluster_snapshot.this.id
}

output "kms_key_id" {
  description = "The Key Management Service (KMS) key ID of the encryption key that was used to encrypt data in the cluster from which the snapshot was taken."
  value       = aws_redshift_cluster_snapshot.this.kms_key_id
}

output "owner_account" {
  description = "For manual snapshots, the Amazon Web Services account used to create or copy the snapshot. For automatic snapshots, the owner of the cluster. The owner can perform all snapshot actions, such as sharing a manual snapshot."
  value       = aws_redshift_cluster_snapshot.this.owner_account
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_redshift_cluster_snapshot.this.tags_all
}