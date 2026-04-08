resource "aws_ec2_subnet_cidr_reservation" "this" {
  cidr_block       = var.cidr_block
  reservation_type = var.reservation_type
  subnet_id        = var.subnet_id
  description      = var.description
  region           = var.region
}