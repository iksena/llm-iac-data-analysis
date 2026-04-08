data "aws_fsx_ontap_storage_virtual_machine" "this" {
  region = var.region
  id     = var.id

  dynamic "filter" {
    for_each = var.filter != null ? [var.filter] : []
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}