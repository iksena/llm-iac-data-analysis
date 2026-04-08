resource "aws_sesv2_dedicated_ip_assignment" "this" {
  ip                    = var.ip
  destination_pool_name = var.destination_pool_name
  region                = var.region
}