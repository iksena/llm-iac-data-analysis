resource "aws_appmesh_virtual_service" "this" {
  region     = var.region
  name       = var.name
  mesh_name  = var.mesh_name
  mesh_owner = var.mesh_owner
  tags       = var.tags

  spec {
    dynamic "provider" {
      for_each = var.spec != null ? [var.spec] : []
      content {
        dynamic "virtual_node" {
          for_each = provider.value.provider != null && provider.value.provider.virtual_node != null ? [provider.value.provider.virtual_node] : []
          content {
            virtual_node_name = virtual_node.value.virtual_node_name
          }
        }

        dynamic "virtual_router" {
          for_each = provider.value.provider != null && provider.value.provider.virtual_router != null ? [provider.value.provider.virtual_router] : []
          content {
            virtual_router_name = virtual_router.value.virtual_router_name
          }
        }
      }
    }
  }
}