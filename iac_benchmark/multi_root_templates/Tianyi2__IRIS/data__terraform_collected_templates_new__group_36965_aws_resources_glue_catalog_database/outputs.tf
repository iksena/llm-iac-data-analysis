output "arn" {
  description = "ARN of the Glue Catalog Database"
  value       = aws_glue_catalog_database.this.arn
}

output "id" {
  description = "Catalog ID and name of the database"
  value       = aws_glue_catalog_database.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_glue_catalog_database.this.tags_all
}