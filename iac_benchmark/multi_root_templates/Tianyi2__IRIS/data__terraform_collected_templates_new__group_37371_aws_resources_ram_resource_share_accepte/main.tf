resource "aws_ram_resource_share_accepter" "this" {
  region    = var.region
  share_arn = var.share_arn
}