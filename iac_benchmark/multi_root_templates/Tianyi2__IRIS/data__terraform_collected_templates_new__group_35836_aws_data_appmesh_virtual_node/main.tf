data "aws_appmesh_virtual_node" "this" {
  region     = var.region
  name       = var.name
  mesh_name  = var.mesh_name
  mesh_owner = var.mesh_owner
}