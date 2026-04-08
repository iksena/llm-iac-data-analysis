resource "aws_keyspaces_table" "this" {
  keyspace_name = var.keyspace_name
  table_name    = var.table_name

  region               = var.region
  default_time_to_live = var.default_time_to_live
  tags                 = var.tags

  dynamic "capacity_specification" {
    for_each = var.capacity_specification != null ? [var.capacity_specification] : []
    content {
      read_capacity_units  = capacity_specification.value.read_capacity_units
      throughput_mode      = capacity_specification.value.throughput_mode
      write_capacity_units = capacity_specification.value.write_capacity_units
    }
  }

  dynamic "client_side_timestamps" {
    for_each = var.client_side_timestamps != null ? [var.client_side_timestamps] : []
    content {
      status = client_side_timestamps.value.status
    }
  }

  dynamic "comment" {
    for_each = var.comment != null ? [var.comment] : []
    content {
      message = comment.value.message
    }
  }

  dynamic "encryption_specification" {
    for_each = var.encryption_specification != null ? [var.encryption_specification] : []
    content {
      kms_key_identifier = encryption_specification.value.kms_key_identifier
      type               = encryption_specification.value.type
    }
  }

  dynamic "point_in_time_recovery" {
    for_each = var.point_in_time_recovery != null ? [var.point_in_time_recovery] : []
    content {
      status = point_in_time_recovery.value.status
    }
  }

  dynamic "schema_definition" {
    for_each = var.schema_definition != null ? [var.schema_definition] : []
    content {
      dynamic "column" {
        for_each = schema_definition.value.column != null ? schema_definition.value.column : []
        content {
          name = column.value.name
          type = column.value.type
        }
      }

      dynamic "partition_key" {
        for_each = schema_definition.value.partition_key != null ? schema_definition.value.partition_key : []
        content {
          name = partition_key.value.name
        }
      }

      dynamic "clustering_key" {
        for_each = schema_definition.value.clustering_key != null ? schema_definition.value.clustering_key : []
        content {
          name     = clustering_key.value.name
          order_by = clustering_key.value.order_by
        }
      }

      dynamic "static_column" {
        for_each = schema_definition.value.static_column != null ? schema_definition.value.static_column : []
        content {
          name = static_column.value.name
        }
      }
    }
  }

  dynamic "ttl" {
    for_each = var.ttl != null ? [var.ttl] : []
    content {
      status = ttl.value.status
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}