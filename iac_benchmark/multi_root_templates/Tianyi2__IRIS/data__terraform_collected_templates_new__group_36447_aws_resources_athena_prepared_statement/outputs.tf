output "id" {
  description = "ID of the prepared statement"
  value       = aws_athena_prepared_statement.this.id
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_athena_prepared_statement.this.region
}

output "name" {
  description = "The name of the prepared statement"
  value       = aws_athena_prepared_statement.this.name
}

output "workgroup" {
  description = "The name of the workgroup to which the prepared statement belongs"
  value       = aws_athena_prepared_statement.this.workgroup
}

output "query_statement" {
  description = "The query string for the prepared statement"
  value       = aws_athena_prepared_statement.this.query_statement
}

output "description" {
  description = "Brief explanation of prepared statement"
  value       = aws_athena_prepared_statement.this.description
}