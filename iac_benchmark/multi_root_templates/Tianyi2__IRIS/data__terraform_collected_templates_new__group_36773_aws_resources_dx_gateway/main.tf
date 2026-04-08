resource "aws_dx_gateway" "this" {
  name            = var.name
  amazon_side_asn = var.amazon_side_asn

  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}