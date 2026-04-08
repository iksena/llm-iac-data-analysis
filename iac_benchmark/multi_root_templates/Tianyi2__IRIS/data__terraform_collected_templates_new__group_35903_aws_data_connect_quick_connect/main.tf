data "aws_connect_quick_connect" "this" {
  instance_id      = var.instance_id
  name             = var.name
  quick_connect_id = var.quick_connect_id
  region           = var.region
}