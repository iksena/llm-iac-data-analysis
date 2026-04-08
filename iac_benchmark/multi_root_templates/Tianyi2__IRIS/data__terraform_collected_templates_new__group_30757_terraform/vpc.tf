# VPC Network
resource "google_compute_network" "vpc_network" {
  name                    = "${var.environment}-coinbreakr-vpc"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

# Public Subnets
resource "google_compute_subnetwork" "public_subnets" {
  count         = 3
  name          = "${var.environment}-public-subnet-${count.index + 1}"
  ip_cidr_range = var.public_subnet_cidrs[count.index]
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

# Private Subnets
resource "google_compute_subnetwork" "private_subnets" {
  count         = 3
  name          = "${var.environment}-private-subnet-${count.index + 1}"
  ip_cidr_range = var.private_subnet_cidrs[count.index]
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

# Internet Gateway (Router for external access)
resource "google_compute_router" "router" {
  name    = "${var.environment}-router"
  region  = var.region
  network = google_compute_network.vpc_network.id
}

# Firewall Rules for SSH, HTTP, HTTPS, and port 3000
resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.environment}-allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["coinbreakr-vm"]
}

resource "google_compute_firewall" "allow_http" {
  name    = "${var.environment}-allow-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["coinbreakr-vm"]
}

resource "google_compute_firewall" "allow_https" {
  name    = "${var.environment}-allow-https"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["coinbreakr-vm"]
}

# Allow load balancer health checks and traffic to app port
resource "google_compute_firewall" "allow_lb_to_instances" {
  name    = "${var.environment}-allow-lb-to-instances"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["3000"]
  }

  # Google Cloud Load Balancer source ranges
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["lb-backend"]
}

# Allow load balancer to reach instances for health checks
resource "google_compute_firewall" "allow_health_check" {
  name    = "${var.environment}-allow-health-check"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["3000"]
  }

  # Health check source ranges
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["lb-backend"]
}

# Get the latest Coinbreakr image
data "google_compute_image" "latest_coinbreakr" {
  family  = var.image_family
  project = var.project_id
}

# Note: Individual VM instance removed - now using managed instance groups for auto scaling

# Outputs
output "vpc_network_name" {
  description = "Name of the VPC network"
  value       = google_compute_network.vpc_network.name
}

output "public_subnet_names" {
  description = "Names of the public subnets"
  value       = google_compute_subnetwork.public_subnets[*].name
}

output "private_subnet_names" {
  description = "Names of the private subnets"
  value       = google_compute_subnetwork.private_subnets[*].name
}

output "managed_instance_group" {
  description = "Name of the managed instance group"
  value       = google_compute_region_instance_group_manager.coinbreakr_group.name
}
