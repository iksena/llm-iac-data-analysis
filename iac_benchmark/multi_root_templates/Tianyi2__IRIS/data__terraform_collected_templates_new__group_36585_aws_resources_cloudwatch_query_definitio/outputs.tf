output "region" {
  description = "Region where this resource is managed"
  value       = aws_cloudwatch_query_definition.this.region
}

output "name" {
  description = "The name of the query"
  value       = aws_cloudwatch_query_definition.this.name
}

output "query_string" {
  description = "The query to save"
  value       = aws_cloudwatch_query_definition.this.query_string
}

output "log_group_names" {
  description = "Specific log groups to use with the query"
  value       = aws_cloudwatch_query_definition.this.log_group_names
}

output "query_definition_id" {
  description = "The query definition ID"
  value       = aws_cloudwatch_query_definition.this.query_definition_id
}