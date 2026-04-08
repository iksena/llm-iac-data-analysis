output "id" {
  description = "The ID of the Data Catalog to set the security configuration for."
  value       = aws_glue_data_catalog_encryption_settings.this.id
}