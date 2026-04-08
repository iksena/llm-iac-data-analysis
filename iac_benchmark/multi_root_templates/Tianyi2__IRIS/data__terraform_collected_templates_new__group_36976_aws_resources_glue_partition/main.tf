resource "aws_glue_partition" "this" {
  region           = var.region
  database_name    = var.database_name
  table_name       = var.table_name
  partition_values = var.partition_values
  catalog_id       = var.catalog_id
  parameters       = var.parameters

  dynamic "storage_descriptor" {
    for_each = var.storage_descriptor != null ? [var.storage_descriptor] : []
    content {
      additional_locations      = storage_descriptor.value.additional_locations
      location                  = storage_descriptor.value.location
      input_format              = storage_descriptor.value.input_format
      output_format             = storage_descriptor.value.output_format
      compressed                = storage_descriptor.value.compressed
      number_of_buckets         = storage_descriptor.value.number_of_buckets
      bucket_columns            = storage_descriptor.value.bucket_columns
      parameters                = storage_descriptor.value.parameters
      stored_as_sub_directories = storage_descriptor.value.stored_as_sub_directories

      dynamic "columns" {
        for_each = storage_descriptor.value.columns != null ? storage_descriptor.value.columns : []
        content {
          name    = columns.value.name
          type    = columns.value.type
          comment = columns.value.comment
        }
      }

      dynamic "ser_de_info" {
        for_each = storage_descriptor.value.ser_de_info != null ? [storage_descriptor.value.ser_de_info] : []
        content {
          name                  = ser_de_info.value.name
          parameters            = ser_de_info.value.parameters
          serialization_library = ser_de_info.value.serialization_library
        }
      }

      dynamic "sort_columns" {
        for_each = storage_descriptor.value.sort_columns != null ? storage_descriptor.value.sort_columns : []
        content {
          column     = sort_columns.value.column
          sort_order = sort_columns.value.sort_order
        }
      }

      dynamic "skewed_info" {
        for_each = storage_descriptor.value.skewed_info != null ? [storage_descriptor.value.skewed_info] : []
        content {
          skewed_column_names               = skewed_info.value.skewed_column_names
          skewed_column_value_location_maps = skewed_info.value.skewed_column_value_location_maps
          skewed_column_values              = skewed_info.value.skewed_column_values
        }
      }
    }
  }
}