resource "aws_vpc_route_server_vpc_association" "this" {
  route_server_id = var.route_server_id
  vpc_id          = var.vpc_id
  region          = var.region

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
  }
}