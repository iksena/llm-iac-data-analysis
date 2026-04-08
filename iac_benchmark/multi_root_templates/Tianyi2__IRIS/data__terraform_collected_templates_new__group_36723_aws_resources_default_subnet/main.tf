resource "aws_default_subnet" "this" {
  availability_zone = var.availability_zone
  force_destroy     = var.force_destroy

  tags = var.tags
}