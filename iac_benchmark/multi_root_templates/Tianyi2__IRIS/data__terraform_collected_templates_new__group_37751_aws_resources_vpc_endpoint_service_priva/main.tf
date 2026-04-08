resource "aws_vpc_endpoint_service_private_dns_verification" "this" {
  service_id            = var.service_id
  region                = var.region
  wait_for_verification = var.wait_for_verification

  timeouts {
    create = var.create_timeout
  }
}