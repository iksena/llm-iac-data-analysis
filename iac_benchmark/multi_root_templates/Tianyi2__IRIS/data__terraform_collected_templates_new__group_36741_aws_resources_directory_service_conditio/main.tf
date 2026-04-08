resource "aws_directory_service_conditional_forwarder" "this" {
  region             = var.region
  directory_id       = var.directory_id
  dns_ips            = var.dns_ips
  remote_domain_name = var.remote_domain_name
}