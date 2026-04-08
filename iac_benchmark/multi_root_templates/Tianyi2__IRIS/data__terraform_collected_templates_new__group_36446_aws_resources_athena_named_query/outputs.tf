output "id" {
  description = "Unique ID of the query"
  value       = aws_athena_named_query.this.id
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_athena_named_query.this.region
}

output "name" {
  description = "Plain language name for the query"
  value       = aws_athena_named_query.this.name
}

output "workgroup" {
  description = "Workgroup to which the query belongs"
  value       = aws_athena_named_query.this.workgroup
}

output "database" {
  description = "Database to which the query belongs"
  value       = aws_athena_named_query.this.database
}

output "query" {
  description = "Text of the query itself"
  value       = aws_athena_named_query.this.query
}

output "description" {
  description = "Brief explanation of the query"
  value       = aws_athena_named_query.this.description
}