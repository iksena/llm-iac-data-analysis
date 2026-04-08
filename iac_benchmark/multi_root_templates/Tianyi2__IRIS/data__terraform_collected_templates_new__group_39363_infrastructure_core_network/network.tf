# Create a new VPC
# Cloud functions that want to access managed SQL instances will send traffic via this network
resource "google_compute_network" "private_network" {
  name = "private-network"
  auto_create_subnetworks = false
  routing_mode = "GLOBAL"
}

# resource "google_compute_firewall" "allow-internal" {
#   name    = "allow-internal"
#   network = "${google_compute_network.private_network.name}"
#   allow {
#     protocol = "icmp"
#   }
#   allow {
#     protocol = "tcp"
#     ports    = ["0-65535"]
#   }
#   allow {
#     protocol = "udp"
#     ports    = ["0-65535"]
#   }
#   source_ranges = [
#     "${var.var_uc1_private_subnet}",
#     "${var.var_ue1_private_subnet}",
#     "${var.var_uc1_public_subnet}",
#     "${var.var_ue1_public_subnet}"
#   ]
# }
