data "aws_guardduty_detector" "this" {
  region = var.region
  id     = var.id
}