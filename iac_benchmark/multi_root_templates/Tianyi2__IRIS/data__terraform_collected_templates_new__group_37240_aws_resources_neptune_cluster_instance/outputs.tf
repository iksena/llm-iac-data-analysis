output "address" {
  description = "The hostname of the instance"
  value       = aws_neptune_cluster_instance.this.address
}

output "arn" {
  description = "Amazon Resource Name (ARN) of neptune instance"
  value       = aws_neptune_cluster_instance.this.arn
}

output "dbi_resource_id" {
  description = "The region-unique, immutable identifier for the neptune instance"
  value       = aws_neptune_cluster_instance.this.dbi_resource_id
}

output "endpoint" {
  description = "The connection endpoint in address:port format"
  value       = aws_neptune_cluster_instance.this.endpoint
}

output "id" {
  description = "The Instance identifier"
  value       = aws_neptune_cluster_instance.this.id
}

output "kms_key_arn" {
  description = "The ARN for the KMS encryption key if one is set to the neptune cluster"
  value       = aws_neptune_cluster_instance.this.kms_key_arn
}

output "storage_encrypted" {
  description = "Specifies whether the neptune cluster is encrypted"
  value       = aws_neptune_cluster_instance.this.storage_encrypted
}

output "storage_type" {
  description = "Storage type associated with the cluster standard/iopt1"
  value       = aws_neptune_cluster_instance.this.storage_type
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_neptune_cluster_instance.this.tags_all
}

output "writer" {
  description = "Boolean indicating if this instance is writable. False indicates this instance is a read replica"
  value       = aws_neptune_cluster_instance.this.writer
}