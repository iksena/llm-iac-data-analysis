output "id" {
  description = "Name of the snapshot."
  value       = data.aws_memorydb_snapshot.this.id
}

output "arn" {
  description = "ARN of the snapshot."
  value       = data.aws_memorydb_snapshot.this.arn
}

output "cluster_configuration" {
  description = "The configuration of the cluster from which the snapshot was taken."
  value       = data.aws_memorydb_snapshot.this.cluster_configuration
}

output "cluster_name" {
  description = "Name of the MemoryDB cluster that this snapshot was taken from."
  value       = data.aws_memorydb_snapshot.this.cluster_name
}

output "kms_key_arn" {
  description = "ARN of the KMS key used to encrypt the snapshot at rest."
  value       = data.aws_memorydb_snapshot.this.kms_key_arn
}

output "source" {
  description = "Whether the snapshot is from an automatic backup (automated) or was created manually (manual)."
  value       = data.aws_memorydb_snapshot.this.source
}

output "tags" {
  description = "Map of tags assigned to the snapshot."
  value       = data.aws_memorydb_snapshot.this.tags
}