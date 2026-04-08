output "creation_time" {
  description = "When the replication configuration was created"
  value       = aws_efs_replication_configuration.this.creation_time
}

output "destination_file_system_id" {
  description = "The fs ID of the replica"
  value       = aws_efs_replication_configuration.this.destination[0].file_system_id
}

output "destination_status" {
  description = "The status of the replication"
  value       = aws_efs_replication_configuration.this.destination[0].status
}

output "original_source_file_system_arn" {
  description = "The Amazon Resource Name (ARN) of the original source Amazon EFS file system in the replication configuration"
  value       = aws_efs_replication_configuration.this.original_source_file_system_arn
}

output "source_file_system_arn" {
  description = "The Amazon Resource Name (ARN) of the current source file system in the replication configuration"
  value       = aws_efs_replication_configuration.this.source_file_system_arn
}

output "source_file_system_region" {
  description = "The AWS Region in which the source Amazon EFS file system is located"
  value       = aws_efs_replication_configuration.this.source_file_system_region
}