output "arn" {
  description = "Amazon Resource Name (ARN) identifier of the KX Scaling Group."
  value       = aws_finspace_kx_scaling_group.this.arn
}

output "clusters" {
  description = "The list of Managed kdb clusters that are currently active in the given scaling group."
  value       = aws_finspace_kx_scaling_group.this.clusters
}

output "created_timestamp" {
  description = "The timestamp at which the scaling group was created in FinSpace. The value is determined as epoch time in milliseconds."
  value       = aws_finspace_kx_scaling_group.this.created_timestamp
}

output "last_modified_timestamp" {
  description = "Last timestamp at which the scaling group was updated in FinSpace. Value determined as epoch time in seconds."
  value       = aws_finspace_kx_scaling_group.this.last_modified_timestamp
}

output "status" {
  description = "The status of scaling group."
  value       = aws_finspace_kx_scaling_group.this.status
}

output "status_reason" {
  description = "The error message when a failed state occurs."
  value       = aws_finspace_kx_scaling_group.this.status_reason
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_finspace_kx_scaling_group.this.tags_all
}