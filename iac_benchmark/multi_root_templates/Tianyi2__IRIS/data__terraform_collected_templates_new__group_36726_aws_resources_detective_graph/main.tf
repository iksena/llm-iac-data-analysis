resource "aws_detective_graph" "this" {
  region = var.region
  tags   = var.tags
}