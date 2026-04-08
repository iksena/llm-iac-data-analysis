resource "aws_ssmcontacts_contact_channel" "this" {
  contact_id = var.contact_id
  name       = var.name
  type       = var.type
  region     = var.region

  delivery_address {
    simple_address = var.delivery_address_simple_address
  }
}