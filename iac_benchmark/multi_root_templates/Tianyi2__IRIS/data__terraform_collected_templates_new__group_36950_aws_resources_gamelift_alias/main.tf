resource "aws_gamelift_alias" "this" {
  region      = var.region
  name        = var.name
  description = var.description

  routing_strategy {
    fleet_id = var.routing_strategy.fleet_id
    message  = var.routing_strategy.message
    type     = var.routing_strategy.type
  }

  tags = var.tags
}