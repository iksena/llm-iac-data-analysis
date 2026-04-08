resource "aws_glue_data_catalog_encryption_settings" "this" {
  region     = var.region
  catalog_id = var.catalog_id

  data_catalog_encryption_settings {
    connection_password_encryption {
      return_connection_password_encrypted = var.data_catalog_encryption_settings.connection_password_encryption.return_connection_password_encrypted
      aws_kms_key_id                       = var.data_catalog_encryption_settings.connection_password_encryption.aws_kms_key_id
    }

    encryption_at_rest {
      catalog_encryption_mode         = var.data_catalog_encryption_settings.encryption_at_rest.catalog_encryption_mode
      catalog_encryption_service_role = var.data_catalog_encryption_settings.encryption_at_rest.catalog_encryption_service_role
      sse_aws_kms_key_id              = var.data_catalog_encryption_settings.encryption_at_rest.sse_aws_kms_key_id
    }
  }
}