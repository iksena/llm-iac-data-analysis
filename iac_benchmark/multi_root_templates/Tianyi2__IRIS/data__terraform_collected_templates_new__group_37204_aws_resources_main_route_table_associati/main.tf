resource "aws_main_route_table_association" "this" {
  region         = var.region
  vpc_id         = var.vpc_id
  route_table_id = var.route_table_id

  timeouts {
    create = var.timeout_create
    update = var.timeout_update
    delete = var.timeout_delete
  }
}