output "data_catalog_encryption_settings" {
  description = "The security configuration to set."
  value       = data.aws_glue_data_catalog_encryption_settings.this.data_catalog_encryption_settings
}

output "connection_password_encryption" {
  description = "Connection password encryption configuration."
  value       = try(data.aws_glue_data_catalog_encryption_settings.this.data_catalog_encryption_settings[0].connection_password_encryption, null)
}

output "encryption_at_rest" {
  description = "Encryption-at-rest configuration for the Data Catalog."
  value       = try(data.aws_glue_data_catalog_encryption_settings.this.data_catalog_encryption_settings[0].encryption_at_rest, null)
}

output "return_connection_password_encrypted" {
  description = "When set to true, passwords remain encrypted in the responses of GetConnection and GetConnections."
  value       = try(data.aws_glue_data_catalog_encryption_settings.this.data_catalog_encryption_settings[0].connection_password_encryption[0].return_connection_password_encrypted, null)
}

output "aws_kms_key_id" {
  description = "KMS key ARN that is used to encrypt the connection password."
  value       = try(data.aws_glue_data_catalog_encryption_settings.this.data_catalog_encryption_settings[0].connection_password_encryption[0].aws_kms_key_id, null)
}

output "catalog_encryption_mode" {
  description = "The encryption-at-rest mode for encrypting Data Catalog data."
  value       = try(data.aws_glue_data_catalog_encryption_settings.this.data_catalog_encryption_settings[0].encryption_at_rest[0].catalog_encryption_mode, null)
}

output "catalog_encryption_service_role" {
  description = "The ARN of the AWS IAM role used for accessing encrypted Data Catalog data."
  value       = try(data.aws_glue_data_catalog_encryption_settings.this.data_catalog_encryption_settings[0].encryption_at_rest[0].catalog_encryption_service_role, null)
}

output "sse_aws_kms_key_id" {
  description = "ARN of the AWS KMS key to use for encryption at rest."
  value       = try(data.aws_glue_data_catalog_encryption_settings.this.data_catalog_encryption_settings[0].encryption_at_rest[0].sse_aws_kms_key_id, null)
}

output "id" {
  description = "The ID of the Data Catalog to set the security configuration for."
  value       = data.aws_glue_data_catalog_encryption_settings.this.id
}