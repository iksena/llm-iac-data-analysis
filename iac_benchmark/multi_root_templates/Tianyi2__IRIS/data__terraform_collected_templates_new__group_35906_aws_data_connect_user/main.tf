data "aws_connect_user" "this" {
  region      = var.region
  instance_id = var.instance_id
  name        = var.name
  user_id     = var.user_id
}