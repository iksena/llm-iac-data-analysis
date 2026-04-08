resource "aws_vpc_route_server_peer" "this" {
  route_server_endpoint_id = var.route_server_endpoint_id
  peer_address             = var.peer_address

  bgp_options {
    peer_asn                = var.bgp_options.peer_asn
    peer_liveness_detection = var.bgp_options.peer_liveness_detection
  }

  region = var.region
  tags   = var.tags

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
    }
  }
}