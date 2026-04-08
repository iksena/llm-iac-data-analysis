resource "aws_comprehend_entity_recognizer" "this" {
  name                 = var.name
  data_access_role_arn = var.data_access_role_arn
  language_code        = var.language_code

  input_data_config {
    data_format = var.input_data_config.data_format

    dynamic "entity_types" {
      for_each = var.input_data_config.entity_types
      content {
        type = entity_types.value.type
      }
    }

    dynamic "annotations" {
      for_each = var.input_data_config.annotations != null ? [var.input_data_config.annotations] : []
      content {
        s3_uri      = annotations.value.s3_uri
        test_s3_uri = annotations.value.test_s3_uri
      }
    }

    dynamic "augmented_manifests" {
      for_each = var.input_data_config.augmented_manifests != null ? var.input_data_config.augmented_manifests : []
      content {
        annotation_data_s3_uri  = augmented_manifests.value.annotation_data_s3_uri
        attribute_names         = augmented_manifests.value.attribute_names
        document_type           = augmented_manifests.value.document_type
        s3_uri                  = augmented_manifests.value.s3_uri
        source_documents_s3_uri = augmented_manifests.value.source_documents_s3_uri
        split                   = augmented_manifests.value.split
      }
    }

    dynamic "documents" {
      for_each = var.input_data_config.documents != null ? [var.input_data_config.documents] : []
      content {
        input_format = documents.value.input_format
        s3_uri       = documents.value.s3_uri
        test_s3_uri  = documents.value.test_s3_uri
      }
    }

    dynamic "entity_list" {
      for_each = var.input_data_config.entity_list != null ? [var.input_data_config.entity_list] : []
      content {
        s3_uri = entity_list.value.s3_uri
      }
    }
  }

  region              = var.region
  model_kms_key_id    = var.model_kms_key_id
  tags                = var.tags
  version_name        = var.version_name
  version_name_prefix = var.version_name_prefix
  volume_kms_key_id   = var.volume_kms_key_id

  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? [var.vpc_config] : []
    content {
      security_group_ids = vpc_config.value.security_group_ids
      subnets            = vpc_config.value.subnets
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}