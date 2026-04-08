resource "aws_timestreamquery_scheduled_query" "this" {
  execution_role_arn = var.execution_role_arn
  name               = var.name
  query_string       = var.query_string
  region             = var.region
  kms_key_id         = var.kms_key_id
  tags               = var.tags

  error_report_configuration {
    s3_configuration {
      bucket_name       = var.error_report_configuration.s3_configuration.bucket_name
      encryption_option = var.error_report_configuration.s3_configuration.encryption_option
      object_key_prefix = var.error_report_configuration.s3_configuration.object_key_prefix
    }
  }

  notification_configuration {
    sns_configuration {
      topic_arn = var.notification_configuration.sns_configuration.topic_arn
    }
  }

  schedule_configuration {
    schedule_expression = var.schedule_configuration.schedule_expression
  }

  target_configuration {
    timestream_configuration {
      database_name       = var.target_configuration.timestream_configuration.database_name
      table_name          = var.target_configuration.timestream_configuration.table_name
      time_column         = var.target_configuration.timestream_configuration.time_column
      measure_name_column = var.target_configuration.timestream_configuration.measure_name_column

      dynamic "dimension_mapping" {
        for_each = var.target_configuration.timestream_configuration.dimension_mapping
        content {
          dimension_value_type = dimension_mapping.value.dimension_value_type
          name                 = dimension_mapping.value.name
        }
      }

      dynamic "mixed_measure_mapping" {
        for_each = var.target_configuration.timestream_configuration.mixed_measure_mapping != null ? [var.target_configuration.timestream_configuration.mixed_measure_mapping] : []
        content {
          measure_name        = mixed_measure_mapping.value.measure_name
          measure_value_type  = mixed_measure_mapping.value.measure_value_type
          source_column       = mixed_measure_mapping.value.source_column
          target_measure_name = mixed_measure_mapping.value.target_measure_name

          dynamic "multi_measure_attribute_mapping" {
            for_each = mixed_measure_mapping.value.multi_measure_attribute_mapping != null ? mixed_measure_mapping.value.multi_measure_attribute_mapping : []
            content {
              measure_value_type                  = multi_measure_attribute_mapping.value.measure_value_type
              source_column                       = multi_measure_attribute_mapping.value.source_column
              target_multi_measure_attribute_name = multi_measure_attribute_mapping.value.target_multi_measure_attribute_name
            }
          }
        }
      }

      dynamic "multi_measure_mappings" {
        for_each = var.target_configuration.timestream_configuration.multi_measure_mappings != null ? var.target_configuration.timestream_configuration.multi_measure_mappings : []
        content {
          target_multi_measure_name = multi_measure_mappings.value.target_multi_measure_name

          dynamic "multi_measure_attribute_mapping" {
            for_each = multi_measure_mappings.value.multi_measure_attribute_mapping
            content {
              measure_value_type                  = multi_measure_attribute_mapping.value.measure_value_type
              source_column                       = multi_measure_attribute_mapping.value.source_column
              target_multi_measure_attribute_name = multi_measure_attribute_mapping.value.target_multi_measure_attribute_name
            }
          }
        }
      }
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}