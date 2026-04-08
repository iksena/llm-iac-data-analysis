data "aws_connect_prompt" "this" {
  region      = var.region
  instance_id = var.instance_id
  name        = var.name
}