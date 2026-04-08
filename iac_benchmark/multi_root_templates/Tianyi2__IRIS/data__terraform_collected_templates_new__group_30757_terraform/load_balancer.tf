# Instance Template for Auto Scaling
resource "google_compute_instance_template" "coinbreakr_template" {
  name_prefix  = "${var.environment}-coinbreakr-template-"
  machine_type = var.machine_type
  region       = var.region

  disk {
    source_image = data.google_compute_image.latest_coinbreakr.self_link
    auto_delete  = true
    boot         = true
    disk_size_gb = 20
    disk_type    = "pd-balanced"
  }

  network_interface {
    subnetwork = google_compute_subnetwork.public_subnets[0].id
    access_config {
      # Ephemeral external IP for instances (can be removed later for security)
    }
  }

  tags = ["coinbreakr-vm", "lb-backend"]

  service_account {
    scopes = ["cloud-platform"]
  }

  # Startup script to ensure service is running
  metadata_startup_script = <<-EOF
    #!/bin/bash
    # Ensure the coinbreakr service is running
    systemctl enable coinbreakr || true
    systemctl start coinbreakr || true
  EOF

  lifecycle {
    create_before_destroy = true
  }
}

# Health Check for Load Balancer
resource "google_compute_health_check" "coinbreakr_health_check" {
  name                = "${var.environment}-coinbreakr-health-check"
  check_interval_sec  = 15
  timeout_sec         = 10
  healthy_threshold   = 2
  unhealthy_threshold = 3

  http_health_check {
    port         = 3000
    request_path = "/v1/healthz" # Adjust this to your app's health endpoint
  }
}

# Managed Instance Group
resource "google_compute_region_instance_group_manager" "coinbreakr_group" {
  name   = "${var.environment}-coinbreakr-group"
  region = var.region

  base_instance_name = "${var.environment}-coinbreakr"
  target_size        = var.min_instances

  version {
    instance_template = google_compute_instance_template.coinbreakr_template.id
  }

  named_port {
    name = "http"
    port = 3000
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.coinbreakr_health_check.id
    initial_delay_sec = 300
  }
}

# Auto Scaler
resource "google_compute_region_autoscaler" "coinbreakr_autoscaler" {
  name   = "${var.environment}-coinbreakr-autoscaler"
  region = var.region
  target = google_compute_region_instance_group_manager.coinbreakr_group.id

  autoscaling_policy {
    max_replicas    = var.max_instances
    min_replicas    = var.min_instances
    cooldown_period = 60

    cpu_utilization {
      target = 0.7
    }
  }
}

# Backend Service
resource "google_compute_backend_service" "coinbreakr_backend" {
  name                  = "${var.environment}-coinbreakr-backend"
  protocol              = "HTTP"
  port_name             = "http"
  load_balancing_scheme = "EXTERNAL"
  timeout_sec           = 30
  health_checks         = [google_compute_health_check.coinbreakr_health_check.id]

  backend {
    group           = google_compute_region_instance_group_manager.coinbreakr_group.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }

  depends_on = [
    google_compute_health_check.coinbreakr_health_check,
    google_compute_region_instance_group_manager.coinbreakr_group,
    time_sleep.wait_for_health_check
  ]
}

# Add a delay to ensure health check is ready
resource "time_sleep" "wait_for_health_check" {
  depends_on = [google_compute_health_check.coinbreakr_health_check]

  create_duration = "30s"
}

# URL Map
resource "google_compute_url_map" "coinbreakr_url_map" {
  name            = "${var.environment}-coinbreakr-url-map"
  default_service = google_compute_backend_service.coinbreakr_backend.id
}

# SSL Certificate (managed by Google)
resource "google_compute_managed_ssl_certificate" "coinbreakr_ssl_cert" {
  name = "${var.environment}-coinbreakr-ssl-cert"

  managed {
    domains = [var.environment == "main" ? "server.splitlyr.clestiq.com" : "staging.splitlyr.clestiq.com"]
  }
}

# HTTPS Proxy
resource "google_compute_target_https_proxy" "coinbreakr_https_proxy" {
  name             = "${var.environment}-coinbreakr-https-proxy"
  url_map          = google_compute_url_map.coinbreakr_url_map.id
  ssl_certificates = [google_compute_managed_ssl_certificate.coinbreakr_ssl_cert.id]
}

# HTTP Proxy (for redirect to HTTPS)
resource "google_compute_target_http_proxy" "coinbreakr_http_proxy" {
  name    = "${var.environment}-coinbreakr-http-proxy"
  url_map = google_compute_url_map.coinbreakr_redirect_url_map.id
}

# URL Map for HTTP to HTTPS redirect
resource "google_compute_url_map" "coinbreakr_redirect_url_map" {
  name = "${var.environment}-coinbreakr-redirect-url-map"

  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}

# Global Forwarding Rule for HTTPS
resource "google_compute_global_forwarding_rule" "coinbreakr_https_forwarding_rule" {
  name       = "${var.environment}-coinbreakr-https-forwarding-rule"
  target     = google_compute_target_https_proxy.coinbreakr_https_proxy.id
  port_range = "443"
}

# Global Forwarding Rule for HTTP (redirect)
resource "google_compute_global_forwarding_rule" "coinbreakr_http_forwarding_rule" {
  name       = "${var.environment}-coinbreakr-http-forwarding-rule"
  target     = google_compute_target_http_proxy.coinbreakr_http_proxy.id
  port_range = "80"
}

# Outputs
output "load_balancer_ip" {
  description = "IP address of the load balancer"
  value       = google_compute_global_forwarding_rule.coinbreakr_https_forwarding_rule.ip_address
}

output "ssl_certificate_name" {
  description = "Name of the SSL certificate"
  value       = google_compute_managed_ssl_certificate.coinbreakr_ssl_cert.name
}