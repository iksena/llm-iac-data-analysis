data "aws_appmesh_gateway_route" "this" {
  region               = var.region
  name                 = var.name
  mesh_name            = var.mesh_name
  virtual_gateway_name = var.virtual_gateway_name
  mesh_owner           = var.mesh_owner
}