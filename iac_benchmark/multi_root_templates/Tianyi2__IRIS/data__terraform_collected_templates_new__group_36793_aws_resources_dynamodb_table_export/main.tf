resource "aws_dynamodb_table_export" "this" {
  s3_bucket = var.s3_bucket
  table_arn = var.table_arn

  region            = var.region
  export_format     = var.export_format
  export_time       = var.export_time
  export_type       = var.export_type
  s3_bucket_owner   = var.s3_bucket_owner
  s3_prefix         = var.s3_prefix
  s3_sse_algorithm  = var.s3_sse_algorithm
  s3_sse_kms_key_id = var.s3_sse_kms_key_id

  dynamic "incremental_export_specification" {
    for_each = var.incremental_export_specification != null ? [var.incremental_export_specification] : []
    content {
      export_from_time = incremental_export_specification.value.export_from_time
      export_to_time   = incremental_export_specification.value.export_to_time
      export_view_type = incremental_export_specification.value.export_view_type
    }
  }

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
  }
}