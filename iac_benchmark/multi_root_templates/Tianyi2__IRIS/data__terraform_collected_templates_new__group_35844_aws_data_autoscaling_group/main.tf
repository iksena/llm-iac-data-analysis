data "aws_autoscaling_group" "this" {
  name   = var.name
  region = var.region
}