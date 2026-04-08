resource "aws_ec2_capacity_block_reservation" "this" {
  capacity_block_offering_id = var.capacity_block_offering_id
  instance_platform          = var.instance_platform
  region                     = var.region
  tags                       = var.tags
}