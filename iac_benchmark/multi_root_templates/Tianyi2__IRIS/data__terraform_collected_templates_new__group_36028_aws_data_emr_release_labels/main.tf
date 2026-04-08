data "aws_emr_release_labels" "this" {
  region = var.region

  dynamic "filters" {
    for_each = var.filters != null ? [var.filters] : []
    content {
      application = filters.value.application
      prefix      = filters.value.prefix
    }
  }
}