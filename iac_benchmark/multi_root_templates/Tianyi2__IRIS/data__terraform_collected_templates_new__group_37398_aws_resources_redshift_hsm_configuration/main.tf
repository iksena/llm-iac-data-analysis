resource "aws_redshift_hsm_configuration" "this" {
  region                        = var.region
  description                   = var.description
  hsm_configuration_identifier  = var.hsm_configuration_identifier
  hsm_ip_address                = var.hsm_ip_address
  hsm_partition_name            = var.hsm_partition_name
  hsm_partition_password        = var.hsm_partition_password
  hsm_server_public_certificate = var.hsm_server_public_certificate
  tags                          = var.tags
}