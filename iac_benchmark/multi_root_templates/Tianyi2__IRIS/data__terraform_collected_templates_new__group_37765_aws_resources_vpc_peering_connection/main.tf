resource "aws_vpc_peering_connection" "this" {
  region        = var.region
  peer_owner_id = var.peer_owner_id
  peer_vpc_id   = var.peer_vpc_id
  vpc_id        = var.vpc_id
  auto_accept   = var.auto_accept
  peer_region   = var.peer_region
  tags          = var.tags

  dynamic "accepter" {
    for_each = var.accepter != null ? [var.accepter] : []
    content {
      allow_remote_vpc_dns_resolution = accepter.value.allow_remote_vpc_dns_resolution
    }
  }

  dynamic "requester" {
    for_each = var.requester != null ? [var.requester] : []
    content {
      allow_remote_vpc_dns_resolution = requester.value.allow_remote_vpc_dns_resolution
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}