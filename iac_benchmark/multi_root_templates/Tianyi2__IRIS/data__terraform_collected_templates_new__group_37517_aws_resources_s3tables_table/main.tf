resource "aws_s3tables_table" "this" {
  format           = var.format
  name             = var.name
  namespace        = var.namespace
  table_bucket_arn = var.table_bucket_arn

  region = var.region


  dynamic "metadata" {
    for_each = var.metadata != null ? [var.metadata] : []
    content {
      dynamic "iceberg" {
        for_each = metadata.value.iceberg != null ? [metadata.value.iceberg] : []
        content {
          schema {
            dynamic "field" {
              for_each = iceberg.value.schema.fields
              content {
                name     = field.value.name
                type     = field.value.type
                required = field.value.required
              }
            }
          }
        }
      }
    }
  }
}