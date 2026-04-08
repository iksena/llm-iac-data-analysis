output "id" {
  description = "Catalog ID, Database name and of the name table."
  value       = data.aws_glue_catalog_table.this.id
}

output "arn" {
  description = "The ARN of the Glue Table."
  value       = data.aws_glue_catalog_table.this.arn
}

output "description" {
  description = "Description of the table."
  value       = data.aws_glue_catalog_table.this.description
}

output "owner" {
  description = "Owner of the table."
  value       = data.aws_glue_catalog_table.this.owner
}

output "parameters" {
  description = "Properties associated with this table, as a list of key-value pairs."
  value       = data.aws_glue_catalog_table.this.parameters
}

output "partition_index" {
  description = "Configuration block for a maximum of 3 partition indexes."
  value       = data.aws_glue_catalog_table.this.partition_index
}

output "partition_keys" {
  description = "Configuration block of columns by which the table is partitioned."
  value       = data.aws_glue_catalog_table.this.partition_keys
}

output "retention" {
  description = "Retention time for this table."
  value       = data.aws_glue_catalog_table.this.retention
}

output "storage_descriptor" {
  description = "Configuration block for information about the physical storage of this table."
  value       = data.aws_glue_catalog_table.this.storage_descriptor
}

output "table_type" {
  description = "Type of this table (EXTERNAL_TABLE, VIRTUAL_VIEW, etc.)."
  value       = data.aws_glue_catalog_table.this.table_type
}

output "target_table" {
  description = "Configuration block of a target table for resource linking."
  value       = data.aws_glue_catalog_table.this.target_table
}

output "view_expanded_text" {
  description = "If the table is a view, the expanded text of the view; otherwise null."
  value       = data.aws_glue_catalog_table.this.view_expanded_text
}

output "view_original_text" {
  description = "If the table is a view, the original text of the view; otherwise null."
  value       = data.aws_glue_catalog_table.this.view_original_text
}