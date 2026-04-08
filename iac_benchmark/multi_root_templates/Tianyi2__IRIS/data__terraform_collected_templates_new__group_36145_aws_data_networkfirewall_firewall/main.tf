data "aws_networkfirewall_firewall" "this" {
  region = var.region
  arn    = var.arn
  name   = var.name
}