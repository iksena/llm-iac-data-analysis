output "arn" {
  description = "ARN of the table replica"
  value       = aws_dynamodb_table_replica.this.arn
}

output "id" {
  description = "Name of the table and region of the main global table joined with a semicolon"
  value       = aws_dynamodb_table_replica.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_dynamodb_table_replica.this.tags_all
}