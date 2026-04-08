resource "aws_eip_domain_name" "this" {
  region        = var.region
  allocation_id = var.allocation_id
  domain_name   = var.domain_name

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}