resource "aws_vpc_block_public_access_exclusion" "this" {
  internet_gateway_exclusion_mode = var.internet_gateway_exclusion_mode
  region                          = var.region
  vpc_id                          = var.vpc_id
  subnet_id                       = var.subnet_id
  tags                            = var.tags

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}