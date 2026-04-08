resource "aws_vpc_security_group_vpc_association" "this" {
  region            = var.region
  security_group_id = var.security_group_id
  vpc_id            = var.vpc_id

  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}