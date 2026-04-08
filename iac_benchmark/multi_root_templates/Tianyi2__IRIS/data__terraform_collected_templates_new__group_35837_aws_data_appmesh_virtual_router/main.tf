data "aws_appmesh_virtual_router" "this" {
  region    = var.region
  name      = var.name
  mesh_name = var.mesh_name
}