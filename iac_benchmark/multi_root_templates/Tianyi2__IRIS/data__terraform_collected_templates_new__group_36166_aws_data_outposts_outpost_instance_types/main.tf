data "aws_outposts_outpost_instance_types" "this" {
  arn    = var.arn
  region = var.region
}