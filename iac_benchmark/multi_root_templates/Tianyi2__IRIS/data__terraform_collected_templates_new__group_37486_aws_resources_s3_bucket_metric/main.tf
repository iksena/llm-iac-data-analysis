resource "aws_s3_bucket_metric" "this" {
  region = var.region
  bucket = var.bucket
  name   = var.name

  dynamic "filter" {
    for_each = var.filter != null ? [var.filter] : []
    content {
      access_point = filter.value.access_point
      prefix       = filter.value.prefix
      tags         = filter.value.tags
    }
  }
}