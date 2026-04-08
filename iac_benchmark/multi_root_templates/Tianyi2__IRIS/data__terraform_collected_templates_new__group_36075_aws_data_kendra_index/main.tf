data "aws_kendra_index" "this" {
  region = var.region
  id     = var.id
}