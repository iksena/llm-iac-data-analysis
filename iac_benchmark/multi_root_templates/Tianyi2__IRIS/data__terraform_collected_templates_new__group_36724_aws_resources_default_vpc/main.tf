resource "aws_default_vpc" "this" {
  force_destroy = var.force_destroy

  tags = var.tags
}