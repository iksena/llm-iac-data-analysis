resource "aws_vpc_endpoint_subnet_association" "this" {
  region          = var.region
  vpc_endpoint_id = var.vpc_endpoint_id
  subnet_id       = var.subnet_id

  timeouts {
    create = var.timeouts_create
    delete = var.timeouts_delete
  }
}