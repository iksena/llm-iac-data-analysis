resource "aws_codebuild_report_group" "this" {
  name           = var.name
  type           = var.type
  delete_reports = var.delete_reports
  tags           = var.tags

  export_config {
    type = var.export_config.type

    dynamic "s3_destination" {
      for_each = var.export_config.type == "S3" ? [var.export_config.s3_destination] : []
      content {
        bucket              = s3_destination.value.bucket
        encryption_key      = s3_destination.value.encryption_key
        encryption_disabled = s3_destination.value.encryption_disabled
        packaging           = s3_destination.value.packaging
        path                = s3_destination.value.path
      }
    }
  }
}