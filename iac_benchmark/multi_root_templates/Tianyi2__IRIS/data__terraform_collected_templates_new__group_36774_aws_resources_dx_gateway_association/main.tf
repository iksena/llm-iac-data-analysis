resource "aws_dx_gateway_association" "this" {
  region                              = var.region
  dx_gateway_id                       = var.dx_gateway_id
  associated_gateway_id               = var.associated_gateway_id
  associated_gateway_owner_account_id = var.associated_gateway_owner_account_id
  proposal_id                         = var.proposal_id
  allowed_prefixes                    = var.allowed_prefixes

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}