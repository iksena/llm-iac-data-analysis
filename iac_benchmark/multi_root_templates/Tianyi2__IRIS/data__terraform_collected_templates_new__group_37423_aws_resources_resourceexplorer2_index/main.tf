resource "aws_resourceexplorer2_index" "this" {
  region = var.region
  type   = var.type
  tags   = var.tags

  timeouts {
    create = var.timeout_create
    update = var.timeout_update
    delete = var.timeout_delete
  }
}