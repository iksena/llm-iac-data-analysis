resource "aws_vpc_route_server_endpoint" "this" {
  route_server_id = var.route_server_id
  subnet_id       = var.subnet_id
  region          = var.region
  tags            = var.tags

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
  }
}