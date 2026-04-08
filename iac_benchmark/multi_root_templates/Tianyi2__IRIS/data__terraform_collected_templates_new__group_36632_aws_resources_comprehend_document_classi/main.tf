resource "aws_comprehend_document_classifier" "this" {
  name                 = var.name
  data_access_role_arn = var.data_access_role_arn
  language_code        = var.language_code

  dynamic "input_data_config" {
    for_each = var.input_data_config != null ? [var.input_data_config] : []
    content {
      data_format     = input_data_config.value.data_format
      label_delimiter = input_data_config.value.label_delimiter
      s3_uri          = input_data_config.value.s3_uri
      test_s3_uri     = input_data_config.value.test_s3_uri

      dynamic "augmented_manifests" {
        for_each = input_data_config.value.augmented_manifests != null ? input_data_config.value.augmented_manifests : []
        content {
          annotation_data_s3_uri  = augmented_manifests.value.annotation_data_s3_uri
          attribute_names         = augmented_manifests.value.attribute_names
          document_type           = augmented_manifests.value.document_type
          s3_uri                  = augmented_manifests.value.s3_uri
          source_documents_s3_uri = augmented_manifests.value.source_documents_s3_uri
          split                   = augmented_manifests.value.split
        }
      }
    }
  }

  region              = var.region
  mode                = var.mode
  model_kms_key_id    = var.model_kms_key_id
  version_name        = var.version_name
  version_name_prefix = var.version_name_prefix
  volume_kms_key_id   = var.volume_kms_key_id

  dynamic "output_data_config" {
    for_each = var.output_data_config != null ? [var.output_data_config] : []
    content {
      kms_key_id = output_data_config.value.kms_key_id
      s3_uri     = output_data_config.value.s3_uri
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? [var.vpc_config] : []
    content {
      security_group_ids = vpc_config.value.security_group_ids
      subnets            = vpc_config.value.subnets
    }
  }

  tags = var.tags

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}