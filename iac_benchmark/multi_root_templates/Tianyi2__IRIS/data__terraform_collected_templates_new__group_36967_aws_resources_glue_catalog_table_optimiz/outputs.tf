output "catalog_id" {
  description = "The Catalog ID of the table."
  value       = aws_glue_catalog_table_optimizer.this.catalog_id
}

output "database_name" {
  description = "The name of the database in the catalog in which the table resides."
  value       = aws_glue_catalog_table_optimizer.this.database_name
}

output "table_name" {
  description = "The name of the table."
  value       = aws_glue_catalog_table_optimizer.this.table_name
}

output "type" {
  description = "The type of table optimizer."
  value       = aws_glue_catalog_table_optimizer.this.type
}

output "region" {
  description = "The region where the resource is managed."
  value       = aws_glue_catalog_table_optimizer.this.region
}