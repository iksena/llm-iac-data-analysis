resource "google_compute_router_nat" "this" {
  name                               = "${local.resource_name}-nat"
  router                             = google_compute_router.this.name
  region                             = data.google_compute_zones.available.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  dynamic "subnetwork" {
    for_each = google_compute_subnetwork.private

    content {
      name                    = subnetwork.value.name
      source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    }
  }
}
