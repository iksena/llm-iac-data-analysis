output "arn" {
  description = "Amazon Resource Name (ARN) identifier of the KX environment."
  value       = aws_finspace_kx_environment.this.arn
}

output "availability_zones" {
  description = "AWS Availability Zone IDs that this environment is available in. Important when selecting VPC subnets to use in cluster creation."
  value       = aws_finspace_kx_environment.this.availability_zones
}

output "created_timestamp" {
  description = "Timestamp at which the environment is created in FinSpace. Value determined as epoch time in seconds. For example, the value for Monday, November 1, 2021 12:00:00 PM UTC is specified as 1635768000."
  value       = aws_finspace_kx_environment.this.created_timestamp
}

output "id" {
  description = "Unique identifier for the KX environment."
  value       = aws_finspace_kx_environment.this.id
}

output "infrastructure_account_id" {
  description = "Unique identifier for the AWS environment infrastructure account."
  value       = aws_finspace_kx_environment.this.infrastructure_account_id
}

output "last_modified_timestamp" {
  description = "Last timestamp at which the environment was updated in FinSpace. Value determined as epoch time in seconds. For example, the value for Monday, November 1, 2021 12:00:00 PM UTC is specified as 1635768000."
  value       = aws_finspace_kx_environment.this.last_modified_timestamp
}

output "status" {
  description = "Status of environment creation."
  value       = aws_finspace_kx_environment.this.status
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_finspace_kx_environment.this.tags_all
}