resource "aws_directory_service_trust" "this" {
  region                                  = var.region
  conditional_forwarder_ip_addrs          = var.conditional_forwarder_ip_addrs
  delete_associated_conditional_forwarder = var.delete_associated_conditional_forwarder
  directory_id                            = var.directory_id
  remote_domain_name                      = var.remote_domain_name
  selective_auth                          = var.selective_auth
  trust_direction                         = var.trust_direction
  trust_password                          = var.trust_password
  trust_type                              = var.trust_type
}