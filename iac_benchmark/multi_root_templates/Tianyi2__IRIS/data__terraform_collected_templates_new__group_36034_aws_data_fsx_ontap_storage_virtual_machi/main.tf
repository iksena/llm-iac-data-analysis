data "aws_fsx_ontap_storage_virtual_machines" "this" {
  region = var.region

  dynamic "filter" {
    for_each = var.filter
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}