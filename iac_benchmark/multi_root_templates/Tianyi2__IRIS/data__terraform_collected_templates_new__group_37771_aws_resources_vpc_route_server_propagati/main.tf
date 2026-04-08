resource "aws_vpc_route_server_propagation" "this" {
  route_server_id = var.route_server_id
  route_table_id  = var.route_table_id
  region          = var.region

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
  }
}