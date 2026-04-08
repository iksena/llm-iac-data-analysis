output "bucket" {
  description = "General purpose bucket that you want to create the metadata configuration for."
  value       = aws_s3_bucket_metadata_configuration.this.bucket
}

output "region" {
  description = "Region where this resource will be managed."
  value       = aws_s3_bucket_metadata_configuration.this.region
}

output "metadata_configuration_destination_table_bucket_arn" {
  description = "ARN of the table bucket where the metadata configuration is stored."
  value       = aws_s3_bucket_metadata_configuration.this.metadata_configuration[0].destination[0].table_bucket_arn
}

output "metadata_configuration_destination_table_bucket_type" {
  description = "Type of the table bucket where the metadata configuration is stored."
  value       = aws_s3_bucket_metadata_configuration.this.metadata_configuration[0].destination[0].table_bucket_type
}

output "metadata_configuration_destination_table_namespace" {
  description = "Namespace in the table bucket where the metadata tables for the metadata configuration are stored."
  value       = aws_s3_bucket_metadata_configuration.this.metadata_configuration[0].destination[0].table_namespace
}

output "metadata_configuration_inventory_table_configuration_table_arn" {
  description = "Inventory table ARN."
  value       = aws_s3_bucket_metadata_configuration.this.metadata_configuration[0].inventory_table_configuration[0].table_arn
}

output "metadata_configuration_inventory_table_configuration_table_name" {
  description = "Inventory table name."
  value       = aws_s3_bucket_metadata_configuration.this.metadata_configuration[0].inventory_table_configuration[0].table_name
}

output "metadata_configuration_journal_table_configuration_table_arn" {
  description = "Journal table ARN."
  value       = aws_s3_bucket_metadata_configuration.this.metadata_configuration[0].journal_table_configuration[0].table_arn
}

output "metadata_configuration_journal_table_configuration_table_name" {
  description = "Journal table name."
  value       = aws_s3_bucket_metadata_configuration.this.metadata_configuration[0].journal_table_configuration[0].table_name
}