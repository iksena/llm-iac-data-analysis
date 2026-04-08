data "aws_outposts_outpost" "this" {
  region   = var.region
  id       = var.id
  name     = var.name
  arn      = var.arn
  owner_id = var.owner_id
}