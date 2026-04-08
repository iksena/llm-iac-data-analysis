resource "aws_route_table_association" "this" {
  region         = var.region
  subnet_id      = var.subnet_id
  gateway_id     = var.gateway_id
  route_table_id = var.route_table_id

  timeouts {
    create = var.timeouts_create
    update = var.timeouts_update
    delete = var.timeouts_delete
  }
}