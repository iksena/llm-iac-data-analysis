resource "aws_placement_group" "this" {
  region          = var.region
  name            = var.name
  partition_count = var.partition_count
  spread_level    = var.spread_level
  strategy        = var.strategy
  tags            = var.tags
}