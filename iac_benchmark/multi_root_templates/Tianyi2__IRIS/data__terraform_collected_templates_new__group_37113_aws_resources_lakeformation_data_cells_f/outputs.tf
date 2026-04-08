output "id" {
  description = "Provider composed identifier: database_name,name,table_catalog_id,table_name."
  value       = aws_lakeformation_data_cells_filter.this.id
}