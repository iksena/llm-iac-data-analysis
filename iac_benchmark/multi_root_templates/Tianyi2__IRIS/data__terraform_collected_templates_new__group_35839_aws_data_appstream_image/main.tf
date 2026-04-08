data "aws_appstream_image" "this" {
  region      = var.region
  name        = var.name
  name_regex  = var.name_regex
  arn         = var.arn
  type        = var.type
  most_recent = var.most_recent
}