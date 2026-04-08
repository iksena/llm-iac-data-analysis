resource "aws_vpc_route_server" "this" {
  amazon_side_asn           = var.amazon_side_asn
  persist_routes            = var.persist_routes
  persist_routes_duration   = var.persist_routes_duration
  region                    = var.region
  sns_notifications_enabled = var.sns_notifications_enabled
  tags                      = var.tags

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}