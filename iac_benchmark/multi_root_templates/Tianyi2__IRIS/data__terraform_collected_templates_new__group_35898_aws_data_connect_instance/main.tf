data "aws_connect_instance" "this" {
  region         = var.region
  instance_id    = var.instance_id
  instance_alias = var.instance_alias
}