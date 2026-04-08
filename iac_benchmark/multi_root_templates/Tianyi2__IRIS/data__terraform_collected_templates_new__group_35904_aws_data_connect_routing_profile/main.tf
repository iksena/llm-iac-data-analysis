data "aws_connect_routing_profile" "this" {
  region             = var.region
  instance_id        = var.instance_id
  name               = var.name
  routing_profile_id = var.routing_profile_id
}