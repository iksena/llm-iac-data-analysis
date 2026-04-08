locals {
  // This ensures that the DNS name is specified as a proper FQDN (i.e. has a trailing `.`)
  safe_internal_dns_name = "${trimsuffix(var.internal_subdomain, ".")}."
}

resource "google_dns_managed_zone" "internal" {
  count = var.internal_subdomain == "" ? 0 : 1

  name        = "internal-${local.resource_name}"
  dns_name    = local.safe_internal_dns_name
  description = "Internal DNS zone for ${local.resource_name}"
  labels      = local.labels
  visibility  = "private"

  private_visibility_config {
    networks {
      network_url = google_compute_network.this.id
    }
  }
}

locals {
  internal_domain_fqdn    = var.internal_subdomain == "" ? "" : google_dns_managed_zone.internal[0].dns_name
  internal_domain_zone_id = var.internal_subdomain == "" ? "" : google_dns_managed_zone.internal[0].name
}
