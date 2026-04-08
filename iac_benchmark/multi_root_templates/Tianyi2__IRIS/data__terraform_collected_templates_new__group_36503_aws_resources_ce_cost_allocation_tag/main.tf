resource "aws_ce_cost_allocation_tag" "this" {
  tag_key = var.tag_key
  status  = var.status
}