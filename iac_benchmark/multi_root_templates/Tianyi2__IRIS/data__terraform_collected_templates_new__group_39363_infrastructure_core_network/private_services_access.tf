# Reserve a range of IP addresses for Private Services access
# Cloud SQL instances will appear in this IP range
# Reference: https://cloud.google.com/vpc/docs/private-services-access
resource "google_compute_global_address" "private_services_ip_address_range" {
  name          = "private-services-ip-address-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.private_network.name
}

# Create a private peering connection between the VPC network and the private services
# This allows anything on the VPC network to access private services (such as Cloud SQL instances) via internal IP addresses
resource "google_service_networking_connection" "private_services_vpc_connection" {
  network                 = google_compute_network.private_network.name
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [ google_compute_global_address.private_services_ip_address_range.name ]
}
