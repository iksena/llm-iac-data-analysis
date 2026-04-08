resource "aws_iot_thing" "this" {
  name            = var.name
  attributes      = var.attributes
  thing_type_name = var.thing_type_name
}