data "aws_vpclattice_auth_policy" "this" {
  region              = var.region
  resource_identifier = var.resource_identifier
}