resource "aws_dx_gateway_association_proposal" "this" {
  region                      = var.region
  associated_gateway_id       = var.associated_gateway_id
  dx_gateway_id               = var.dx_gateway_id
  dx_gateway_owner_account_id = var.dx_gateway_owner_account_id
  allowed_prefixes            = var.allowed_prefixes
}