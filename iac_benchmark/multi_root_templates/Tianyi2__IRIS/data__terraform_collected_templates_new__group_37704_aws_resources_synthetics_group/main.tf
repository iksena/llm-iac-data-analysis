resource "aws_synthetics_group" "this" {
  name   = var.name
  region = var.region
  tags   = var.tags
}