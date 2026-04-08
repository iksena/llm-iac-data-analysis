resource "aws_s3_bucket_intelligent_tiering_configuration" "this" {
  region = var.region
  bucket = var.bucket
  name   = var.name
  status = var.status

  dynamic "filter" {
    for_each = var.filter != null ? [var.filter] : []
    content {
      prefix = filter.value.prefix
      tags   = filter.value.tags
    }
  }

  dynamic "tiering" {
    for_each = var.tiering
    content {
      access_tier = tiering.value.access_tier
      days        = tiering.value.days
    }
  }
}