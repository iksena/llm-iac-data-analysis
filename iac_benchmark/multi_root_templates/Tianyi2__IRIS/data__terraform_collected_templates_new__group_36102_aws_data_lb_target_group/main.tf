data "aws_lb_target_group" "this" {
  region = var.region
  arn    = var.arn
  name   = var.name
  tags   = var.tags

  timeouts {
    read = var.timeouts_read
  }
}