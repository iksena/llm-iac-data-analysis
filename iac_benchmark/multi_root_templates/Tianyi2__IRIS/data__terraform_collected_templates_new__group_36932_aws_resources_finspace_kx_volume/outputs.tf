output "arn" {
  value       = aws_finspace_kx_volume.this.arn
  description = "Amazon Resource Name (ARN) identifier of the KX volume."
}

output "created_timestamp" {
  value       = aws_finspace_kx_volume.this.created_timestamp
  description = "The timestamp at which the volume was created in FinSpace. The value is determined as epoch time in milliseconds."
}

output "status" {
  value       = aws_finspace_kx_volume.this.status
  description = "The status of volume creation."
}

output "status_reason" {
  value       = aws_finspace_kx_volume.this.status_reason
  description = "The error message when a failed state occurs."
}

output "last_modified_timestamp" {
  value       = aws_finspace_kx_volume.this.last_modified_timestamp
  description = "Last timestamp at which the volume was updated in FinSpace. Value determined as epoch time in seconds."
}

output "id" {
  value       = aws_finspace_kx_volume.this.id
  description = "The ID of the FinSpace Kx Volume."
}

output "name" {
  value       = aws_finspace_kx_volume.this.name
  description = "The name of the FinSpace Kx Volume."
}

output "environment_id" {
  value       = aws_finspace_kx_volume.this.environment_id
  description = "The environment ID of the FinSpace Kx Volume."
}

output "availability_zones" {
  value       = aws_finspace_kx_volume.this.availability_zones
  description = "The availability zones of the FinSpace Kx Volume."
}

output "az_mode" {
  value       = aws_finspace_kx_volume.this.az_mode
  description = "The availability zone mode of the FinSpace Kx Volume."
}

output "type" {
  value       = aws_finspace_kx_volume.this.type
  description = "The type of the FinSpace Kx Volume."
}

output "description" {
  value       = aws_finspace_kx_volume.this.description
  description = "The description of the FinSpace Kx Volume."
}

output "region" {
  value       = aws_finspace_kx_volume.this.region
  description = "The region of the FinSpace Kx Volume."
}

output "tags" {
  value       = aws_finspace_kx_volume.this.tags
  description = "The tags of the FinSpace Kx Volume."
}

output "nas1_configuration" {
  value       = aws_finspace_kx_volume.this.nas1_configuration
  description = "The NAS1 configuration of the FinSpace Kx Volume."
}