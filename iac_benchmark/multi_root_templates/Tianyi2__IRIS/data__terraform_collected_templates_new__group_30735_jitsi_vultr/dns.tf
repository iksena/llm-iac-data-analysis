# https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/data-sources/zone
data "cloudflare_zone" "domain" {
  filter = {
    name = var.domain
  }
}

# https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record
resource "cloudflare_dns_record" "www_ipv4" {
  zone_id = data.cloudflare_zone.domain.id
  name    = local.subdomain
  type    = "A"
  content = vultr_instance.server.main_ip
  ttl     = 1800
}

# https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record
resource "cloudflare_dns_record" "www_ipv6" {
  zone_id = data.cloudflare_zone.domain.id
  name    = local.subdomain
  type    = "AAAA"
  content = vultr_instance.server.v6_main_ip
  ttl     = 1800
}
