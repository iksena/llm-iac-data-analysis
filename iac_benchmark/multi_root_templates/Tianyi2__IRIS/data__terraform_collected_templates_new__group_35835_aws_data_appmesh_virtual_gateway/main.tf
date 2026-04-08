data "aws_appmesh_virtual_gateway" "this" {
  name      = var.name
  mesh_name = var.mesh_name
  region    = var.region
}