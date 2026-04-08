resource "aws_route53domains_delegation_signer_record" "this" {
  domain_name = var.domain_name

  signing_attributes {
    algorithm  = var.signing_attributes_algorithm
    flags      = var.signing_attributes_flags
    public_key = var.signing_attributes_public_key
  }

  timeouts {
    create = var.timeouts_create
    delete = var.timeouts_delete
  }
}