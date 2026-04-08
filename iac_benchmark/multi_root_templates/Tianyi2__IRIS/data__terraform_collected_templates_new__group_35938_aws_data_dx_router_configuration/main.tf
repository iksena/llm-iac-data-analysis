data "aws_dx_router_configuration" "this" {
  region                 = var.region
  virtual_interface_id   = var.virtual_interface_id
  router_type_identifier = var.router_type_identifier
}