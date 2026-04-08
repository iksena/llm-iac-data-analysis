data "aws_sns_topic" "this" {
  name   = var.name
  region = var.region
}