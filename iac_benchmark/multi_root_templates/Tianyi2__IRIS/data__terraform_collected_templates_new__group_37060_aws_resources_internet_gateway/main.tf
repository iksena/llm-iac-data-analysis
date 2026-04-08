resource "aws_internet_gateway" "this" {
  region = var.region
  vpc_id = var.vpc_id
  tags   = var.tags

  timeouts {
    create = var.timeout_create
    update = var.timeout_update
    delete = var.timeout_delete
  }
}