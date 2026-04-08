resource "aws_opensearch_outbound_connection" "this" {
  region            = var.region
  connection_alias  = var.connection_alias
  connection_mode   = var.connection_mode
  accept_connection = var.accept_connection

  dynamic "connection_properties" {
    for_each = var.connection_properties != null ? [var.connection_properties] : []
    content {
      dynamic "cross_cluster_search" {
        for_each = connection_properties.value.cross_cluster_search != null ? [connection_properties.value.cross_cluster_search] : []
        content {
          skip_unavailable = cross_cluster_search.value.skip_unavailable
        }
      }
    }
  }

  local_domain_info {
    owner_id    = var.local_domain_info.owner_id
    domain_name = var.local_domain_info.domain_name
    region      = var.local_domain_info.region
  }

  remote_domain_info {
    owner_id    = var.remote_domain_info.owner_id
    domain_name = var.remote_domain_info.domain_name
    region      = var.remote_domain_info.region
  }

  timeouts {
    create = "5m"
    delete = "5m"
  }
}