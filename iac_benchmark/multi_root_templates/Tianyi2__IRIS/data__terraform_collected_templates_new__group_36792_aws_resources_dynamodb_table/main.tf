resource "aws_dynamodb_table" "this" {
  name           = var.name
  region         = var.region
  billing_mode   = var.billing_mode
  hash_key       = var.hash_key
  range_key      = var.range_key
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity

  deletion_protection_enabled = var.deletion_protection_enabled
  stream_enabled              = var.stream_enabled
  stream_view_type            = var.stream_view_type
  table_class                 = var.table_class
  restore_date_time           = var.restore_date_time
  restore_source_name         = var.restore_source_name
  restore_source_table_arn    = var.restore_source_table_arn
  restore_to_latest_time      = var.restore_to_latest_time

  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes
    content {
      name               = global_secondary_index.value.name
      hash_key           = global_secondary_index.value.hash_key
      range_key          = global_secondary_index.value.range_key
      projection_type    = global_secondary_index.value.projection_type
      non_key_attributes = global_secondary_index.value.non_key_attributes
      read_capacity      = global_secondary_index.value.read_capacity
      write_capacity     = global_secondary_index.value.write_capacity

      dynamic "on_demand_throughput" {
        for_each = global_secondary_index.value.on_demand_throughput != null ? [global_secondary_index.value.on_demand_throughput] : []
        content {
          max_read_request_units  = on_demand_throughput.value.max_read_request_units
          max_write_request_units = on_demand_throughput.value.max_write_request_units
        }
      }

      dynamic "warm_throughput" {
        for_each = global_secondary_index.value.warm_throughput != null ? [global_secondary_index.value.warm_throughput] : []
        content {
          read_units_per_second  = warm_throughput.value.read_units_per_second
          write_units_per_second = warm_throughput.value.write_units_per_second
        }
      }
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.local_secondary_indexes
    content {
      name               = local_secondary_index.value.name
      range_key          = local_secondary_index.value.range_key
      projection_type    = local_secondary_index.value.projection_type
      non_key_attributes = local_secondary_index.value.non_key_attributes
    }
  }

  dynamic "on_demand_throughput" {
    for_each = var.on_demand_throughput != null ? [var.on_demand_throughput] : []
    content {
      max_read_request_units  = on_demand_throughput.value.max_read_request_units
      max_write_request_units = on_demand_throughput.value.max_write_request_units
    }
  }

  dynamic "point_in_time_recovery" {
    for_each = var.point_in_time_recovery != null ? [var.point_in_time_recovery] : []
    content {
      enabled                 = point_in_time_recovery.value.enabled
      recovery_period_in_days = point_in_time_recovery.value.recovery_period_in_days
    }
  }

  dynamic "replica" {
    for_each = var.replicas
    content {
      region_name                 = replica.value.region_name
      consistency_mode            = replica.value.consistency_mode
      kms_key_arn                 = replica.value.kms_key_arn
      point_in_time_recovery      = replica.value.point_in_time_recovery
      deletion_protection_enabled = replica.value.deletion_protection_enabled
      propagate_tags              = replica.value.propagate_tags
    }
  }

  dynamic "server_side_encryption" {
    for_each = var.server_side_encryption != null ? [var.server_side_encryption] : []
    content {
      enabled     = server_side_encryption.value.enabled
      kms_key_arn = server_side_encryption.value.kms_key_arn
    }
  }

  dynamic "ttl" {
    for_each = var.ttl != null ? [var.ttl] : []
    content {
      attribute_name = ttl.value.attribute_name
      enabled        = ttl.value.enabled
    }
  }

  dynamic "warm_throughput" {
    for_each = var.warm_throughput != null ? [var.warm_throughput] : []
    content {
      read_units_per_second  = warm_throughput.value.read_units_per_second
      write_units_per_second = warm_throughput.value.write_units_per_second
    }
  }

  dynamic "import_table" {
    for_each = var.import_table != null ? [var.import_table] : []
    content {
      input_compression_type = import_table.value.input_compression_type
      input_format           = import_table.value.input_format

      dynamic "input_format_options" {
        for_each = import_table.value.input_format_options != null ? [import_table.value.input_format_options] : []
        content {
          dynamic "csv" {
            for_each = input_format_options.value.csv != null ? [input_format_options.value.csv] : []
            content {
              delimiter   = csv.value.delimiter
              header_list = csv.value.header_list
            }
          }
        }
      }

      s3_bucket_source {
        bucket       = import_table.value.s3_bucket_source.bucket
        bucket_owner = import_table.value.s3_bucket_source.bucket_owner
        key_prefix   = import_table.value.s3_bucket_source.key_prefix
      }
    }
  }

  tags = var.tags

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}