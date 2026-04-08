resource "aws_appstream_fleet_stack_association" "this" {
  region     = var.region
  fleet_name = var.fleet_name
  stack_name = var.stack_name
}