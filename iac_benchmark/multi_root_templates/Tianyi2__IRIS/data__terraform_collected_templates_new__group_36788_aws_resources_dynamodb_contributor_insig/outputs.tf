output "region" {
  description = "Region where this resource is managed"
  value       = aws_dynamodb_contributor_insights.this.region
}

output "table_name" {
  description = "The name of the table to enable contributor insights"
  value       = aws_dynamodb_contributor_insights.this.table_name
}

output "index_name" {
  description = "The global secondary index name"
  value       = aws_dynamodb_contributor_insights.this.index_name
}

output "mode" {
  description = "CloudWatch contributor insights mode"
  value       = aws_dynamodb_contributor_insights.this.mode
}