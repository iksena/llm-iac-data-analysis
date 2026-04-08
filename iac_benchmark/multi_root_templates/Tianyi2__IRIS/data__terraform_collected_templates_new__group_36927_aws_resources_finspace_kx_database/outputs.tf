output "arn" {
  description = "Amazon Resource Name (ARN) identifier of the KX database"
  value       = aws_finspace_kx_database.this.arn
}

output "created_timestamp" {
  description = "Timestamp at which the database is created in FinSpace. Value determined as epoch time in seconds"
  value       = aws_finspace_kx_database.this.created_timestamp
}

output "id" {
  description = "A comma-delimited string joining environment ID and database name"
  value       = aws_finspace_kx_database.this.id
}

output "last_modified_timestamp" {
  description = "Last timestamp at which the database was updated in FinSpace. Value determined as epoch time in seconds"
  value       = aws_finspace_kx_database.this.last_modified_timestamp
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_finspace_kx_database.this.tags_all
}