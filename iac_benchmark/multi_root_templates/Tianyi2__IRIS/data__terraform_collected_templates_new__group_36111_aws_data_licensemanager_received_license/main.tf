data "aws_licensemanager_received_licenses" "this" {
  region = var.region

  dynamic "filter" {
    for_each = var.filter
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}