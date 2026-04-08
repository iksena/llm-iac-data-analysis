resource "aws_verifiedaccess_instance_trust_provider_attachment" "this" {
  region                           = var.region
  verifiedaccess_instance_id       = var.verifiedaccess_instance_id
  verifiedaccess_trust_provider_id = var.verifiedaccess_trust_provider_id
}