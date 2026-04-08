output "arn" {
  description = "Amazon Resource Name (ARN) identifier of the KX dataview"
  value       = aws_finspace_kx_dataview.this.arn
}

output "created_timestamp" {
  description = "Timestamp at which the dataview was created in FinSpace. Value determined as epoch time in milliseconds. For example, the value for Monday, November 1, 2021 12:00:00 PM UTC is specified as 1635768000000"
  value       = aws_finspace_kx_dataview.this.created_timestamp
}

output "id" {
  description = "A comma-delimited string joining environment ID, database name and dataview name"
  value       = aws_finspace_kx_dataview.this.id
}

output "last_modified_timestamp" {
  description = "The last time that the dataview was updated in FinSpace. The value is determined as epoch time in milliseconds. For example, the value for Monday, November 1, 2021 12:00:00 PM UTC is specified as 1635768000000"
  value       = aws_finspace_kx_dataview.this.last_modified_timestamp
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_finspace_kx_dataview.this.tags_all
}