output "id" {
  description = "Catalog ID, Database name, table name, and index name."
  value       = aws_glue_partition_index.this.id
}