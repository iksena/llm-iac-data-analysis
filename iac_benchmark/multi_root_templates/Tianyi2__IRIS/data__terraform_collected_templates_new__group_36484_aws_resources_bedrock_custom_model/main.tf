resource "aws_bedrock_custom_model" "this" {
  region                  = var.region
  base_model_identifier   = var.base_model_identifier
  custom_model_kms_key_id = var.custom_model_kms_key_id
  custom_model_name       = var.custom_model_name
  customization_type      = var.customization_type
  hyperparameters         = var.hyperparameters
  job_name                = var.job_name
  role_arn                = var.role_arn
  tags                    = var.tags

  output_data_config {
    s3_uri = var.output_data_config.s3_uri
  }

  training_data_config {
    s3_uri = var.training_data_config.s3_uri
  }

  dynamic "validation_data_config" {
    for_each = var.validation_data_config != null ? [var.validation_data_config] : []
    content {
      dynamic "validator" {
        for_each = validation_data_config.value.validator != null ? [validation_data_config.value.validator] : []
        content {
          s3_uri = validator.value.s3_uri
        }
      }
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? [var.vpc_config] : []
    content {
      security_group_ids = vpc_config.value.security_group_ids
      subnet_ids         = vpc_config.value.subnet_ids
    }
  }

  timeouts {
    delete = var.timeouts.delete
  }
}