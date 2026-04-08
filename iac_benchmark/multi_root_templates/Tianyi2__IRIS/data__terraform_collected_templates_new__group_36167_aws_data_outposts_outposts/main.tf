data "aws_outposts_outposts" "this" {
  region               = var.region
  availability_zone    = var.availability_zone
  availability_zone_id = var.availability_zone_id
  site_id              = var.site_id
  owner_id             = var.owner_id
}