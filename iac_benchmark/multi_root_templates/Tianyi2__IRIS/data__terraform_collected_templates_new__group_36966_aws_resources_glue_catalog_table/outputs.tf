output "arn" {
  description = "The ARN of the Glue Table."
  value       = aws_glue_catalog_table.this.arn
}

output "id" {
  description = "Catalog ID, Database name and of the name table."
  value       = aws_glue_catalog_table.this.id
}