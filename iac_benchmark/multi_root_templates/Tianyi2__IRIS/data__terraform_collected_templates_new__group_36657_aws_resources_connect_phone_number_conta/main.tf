resource "aws_connect_phone_number_contact_flow_association" "this" {
  contact_flow_id = var.contact_flow_id
  instance_id     = var.instance_id
  phone_number_id = var.phone_number_id
  region          = var.region
}