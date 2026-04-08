resource "google_compute_network" "this" {
  name                            = local.resource_name
  auto_create_subnetworks         = false
  routing_mode                    = "GLOBAL"
  project                         = data.google_compute_zones.available.project
  description                     = "Managed by Nullstone"
  delete_default_routes_on_create = false
  mtu                             = 0
}

resource "google_compute_router" "this" {
  name    = "${local.resource_name}-router"
  network = google_compute_network.this.name
  region  = data.google_compute_zones.available.region

  bgp {
    asn            = 64514
    advertise_mode = "CUSTOM"
  }
}
