output "arn" {
  description = "Amazon Resource Name of the file system."
  value       = data.aws_efs_file_system.this.arn
}

output "availability_zone_name" {
  description = "The Availability Zone name in which the file system's One Zone storage classes exist."
  value       = data.aws_efs_file_system.this.availability_zone_name
}

output "availability_zone_id" {
  description = "The identifier of the Availability Zone in which the file system's One Zone storage classes exist."
  value       = data.aws_efs_file_system.this.availability_zone_id
}

output "dns_name" {
  description = "DNS name for the filesystem per documented convention."
  value       = data.aws_efs_file_system.this.dns_name
}

output "encrypted" {
  description = "Whether EFS is encrypted."
  value       = data.aws_efs_file_system.this.encrypted
}

output "kms_key_id" {
  description = "ARN for the KMS encryption key."
  value       = data.aws_efs_file_system.this.kms_key_id
}

output "lifecycle_policy" {
  description = "File system lifecycle policy object."
  value       = data.aws_efs_file_system.this.lifecycle_policy
}

output "name" {
  description = "The value of the file system's Name tag."
  value       = data.aws_efs_file_system.this.name
}

output "performance_mode" {
  description = "File system performance mode."
  value       = data.aws_efs_file_system.this.performance_mode
}

output "provisioned_throughput_in_mibps" {
  description = "The throughput, measured in MiB/s, that you want to provision for the file system."
  value       = data.aws_efs_file_system.this.provisioned_throughput_in_mibps
}

output "tags" {
  description = "A map of tags to assign to the file system."
  value       = data.aws_efs_file_system.this.tags
}

output "throughput_mode" {
  description = "Throughput mode for the file system."
  value       = data.aws_efs_file_system.this.throughput_mode
}

output "size_in_bytes" {
  description = "Current byte count used by the file system."
  value       = data.aws_efs_file_system.this.size_in_bytes
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_efs_file_system.this.region
}

output "file_system_id" {
  description = "ID that identifies the file system."
  value       = data.aws_efs_file_system.this.file_system_id
}

output "creation_token" {
  description = "Creation token of the file system."
  value       = data.aws_efs_file_system.this.creation_token
}