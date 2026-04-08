data "aws_networkfirewall_firewall_policy" "this" {
  arn    = var.arn
  name   = var.name
  region = var.region
}