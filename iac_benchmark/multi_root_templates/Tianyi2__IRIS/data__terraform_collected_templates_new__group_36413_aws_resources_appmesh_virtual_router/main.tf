resource "aws_appmesh_virtual_router" "this" {
  region     = var.region
  name       = var.name
  mesh_name  = var.mesh_name
  mesh_owner = var.mesh_owner
  tags       = var.tags

  spec {
    dynamic "listener" {
      for_each = var.listeners
      content {
        port_mapping {
          port     = listener.value.port
          protocol = listener.value.protocol
        }
      }
    }
  }
}