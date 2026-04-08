resource "aws_evidently_segment" "this" {
  region      = var.region
  description = var.description
  name        = var.name
  pattern     = var.pattern
  tags        = var.tags
}