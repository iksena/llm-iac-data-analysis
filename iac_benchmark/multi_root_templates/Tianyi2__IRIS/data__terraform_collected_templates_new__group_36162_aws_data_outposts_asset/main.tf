data "aws_outposts_asset" "this" {
  region   = var.region
  arn      = var.arn
  asset_id = var.asset_id
}