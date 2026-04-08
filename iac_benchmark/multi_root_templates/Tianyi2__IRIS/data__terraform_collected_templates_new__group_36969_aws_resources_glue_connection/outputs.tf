output "arn" {
  description = "ARN of the Glue Connection."
  value       = aws_glue_connection.this.arn
}

output "id" {
  description = "Catalog ID and name of the connection."
  value       = aws_glue_connection.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_glue_connection.this.tags_all
}