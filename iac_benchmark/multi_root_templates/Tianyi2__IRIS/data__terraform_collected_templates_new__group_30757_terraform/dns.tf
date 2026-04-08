# Reference existing DNS Zone for splitlyr.clestiq.com
data "google_dns_managed_zone" "splitlyr_zone" {
  name = var.dns_zone_name
}

# A record for API subdomain (main environment) - points to load balancer
resource "google_dns_record_set" "api_record" {
  count = var.environment == "main" ? 1 : 0

  name         = "server.splitlyr.clestiq.com."
  managed_zone = data.google_dns_managed_zone.splitlyr_zone.name
  type         = "A"
  ttl          = 300
  rrdatas      = [google_compute_global_forwarding_rule.coinbreakr_https_forwarding_rule.ip_address]
}

# A record for staging subdomain (staging environment) - points to load balancer
resource "google_dns_record_set" "staging_record" {
  count = var.environment == "staging" ? 1 : 0

  name         = "staging.splitlyr.clestiq.com."
  managed_zone = data.google_dns_managed_zone.splitlyr_zone.name
  type         = "A"
  ttl          = 300
  rrdatas      = [google_compute_global_forwarding_rule.coinbreakr_https_forwarding_rule.ip_address]
}

# Output the DNS records created
output "dns_records" {
  description = "DNS records created"
  value = {
    api_record     = var.environment == "main" ? "server.splitlyr.clestiq.com -> ${google_compute_global_forwarding_rule.coinbreakr_https_forwarding_rule.ip_address}" : "Not created in this environment"
    staging_record = var.environment == "staging" ? "staging.splitlyr.clestiq.com -> ${google_compute_global_forwarding_rule.coinbreakr_https_forwarding_rule.ip_address}" : "Not created in this environment"
  }
}