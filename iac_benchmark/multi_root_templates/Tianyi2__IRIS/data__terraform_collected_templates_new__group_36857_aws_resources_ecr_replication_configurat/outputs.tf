output "registry_id" {
  description = "The registry ID where the replication configuration was created."
  value       = aws_ecr_replication_configuration.this.registry_id
}