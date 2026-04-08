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
  content = aws_instance.vpn.public_ip
  ttl     = 1800
}
