resource "aws_inspector_resource_group" "this" {
  region = var.region
  tags   = var.tags
}