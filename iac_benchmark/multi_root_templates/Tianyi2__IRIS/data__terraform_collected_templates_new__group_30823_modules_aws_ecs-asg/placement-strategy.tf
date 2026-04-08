resource "aws_placement_group" "strategy" {
  count  = var.create_placement_strategy ? 1 : 0
  name     = "${var.cluster_name}-placement-strategy-${var.placement_strategy}"
  strategy = var.placement_strategy
}