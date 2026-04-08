data "aws_launch_configuration" "this" {
  name   = var.name
  region = var.region
}