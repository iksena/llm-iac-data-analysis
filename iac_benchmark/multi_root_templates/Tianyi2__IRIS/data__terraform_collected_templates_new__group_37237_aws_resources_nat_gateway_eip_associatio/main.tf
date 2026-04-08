resource "aws_nat_gateway_eip_association" "this" {
  allocation_id  = var.allocation_id
  nat_gateway_id = var.nat_gateway_id
  region         = var.region

  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}