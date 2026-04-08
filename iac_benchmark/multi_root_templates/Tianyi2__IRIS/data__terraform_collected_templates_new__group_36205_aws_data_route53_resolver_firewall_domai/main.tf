data "aws_route53_resolver_firewall_domain_list" "this" {
  firewall_domain_list_id = var.firewall_domain_list_id
  region                  = var.region
}