data "aws_appmesh_mesh" "this" {
  region     = var.region
  name       = var.name
  mesh_owner = var.mesh_owner
}