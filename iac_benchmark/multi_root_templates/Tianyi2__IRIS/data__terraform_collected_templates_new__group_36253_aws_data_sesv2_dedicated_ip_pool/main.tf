data "aws_sesv2_dedicated_ip_pool" "this" {
  pool_name = var.pool_name
  region    = var.region
}