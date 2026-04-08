resource "aws_iot_thing_group_membership" "this" {
  region                 = var.region
  thing_name             = var.thing_name
  thing_group_name       = var.thing_group_name
  override_dynamic_group = var.override_dynamic_group
}