data "aws_appmesh_route" "this" {
  name                = var.name
  mesh_name           = var.mesh_name
  virtual_router_name = var.virtual_router_name
  mesh_owner          = var.mesh_owner
  region              = var.region
}