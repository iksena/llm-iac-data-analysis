resource "aws_iot_thing_principal_attachment" "this" {
  region               = var.region
  principal            = var.principal
  thing                = var.thing
  thing_principal_type = var.thing_principal_type
}