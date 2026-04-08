resource "aws_bcmdataexports_export" "this" {
  export {
    name        = var.export_name
    description = var.export_description

    data_query {
      query_statement      = var.data_query_statement
      table_configurations = var.data_query_table_configurations
    }

    destination_configurations {
      s3_destination {
        s3_bucket = var.s3_bucket
        s3_prefix = var.s3_prefix
        s3_region = var.s3_region

        s3_output_configurations {
          compression = var.s3_output_compression
          format      = var.s3_output_format
          output_type = var.s3_output_type
          overwrite   = var.s3_output_overwrite
        }
      }
    }

    refresh_cadence {
      frequency = var.refresh_cadence_frequency
    }
  }

  timeouts {
    create = var.timeout_create
    update = var.timeout_update
  }
}