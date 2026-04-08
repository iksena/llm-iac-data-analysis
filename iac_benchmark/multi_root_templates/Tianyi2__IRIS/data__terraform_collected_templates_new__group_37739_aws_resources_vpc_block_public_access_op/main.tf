resource "aws_vpc_block_public_access_options" "this" {
  region                      = var.region
  internet_gateway_block_mode = var.internet_gateway_block_mode

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}