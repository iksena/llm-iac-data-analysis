data "aws_oam_link" "this" {
  region          = var.region
  link_identifier = var.link_identifier
}