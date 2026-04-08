output "database" {
  description = "Database to which the query belongs."
  value       = data.aws_athena_named_query.this.database
}

output "description" {
  description = "Brief explanation of the query."
  value       = data.aws_athena_named_query.this.description
}

output "id" {
  description = "The unique ID of the query."
  value       = data.aws_athena_named_query.this.id
}

output "query" {
  description = "Text of the query itself."
  value       = data.aws_athena_named_query.this.querystring
}

output "name" {
  description = "The plain language name for the query."
  value       = data.aws_athena_named_query.this.name
}

output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_athena_named_query.this.region
}

output "workgroup" {
  description = "The workgroup to which the query belongs."
  value       = data.aws_athena_named_query.this.workgroup
}