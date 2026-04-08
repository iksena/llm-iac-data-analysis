data "aws_outposts_site" "this" {
  region = var.region
  id     = var.id
  name   = var.name
}