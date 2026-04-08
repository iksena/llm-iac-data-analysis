resource "google_compute_global_forwarding_rule" "app" {
  name       = "reddit-app-http-forward"
  target     = "${google_compute_target_http_proxy.app.self_link}"
  port_range = "80"
}

resource "google_compute_target_http_proxy" "app" {
  name        = "reddit-app-http-proxy"
  description = "checks each request against a URL map to detemine the appropriate backend service for the request"
  url_map     = "${google_compute_url_map.app.self_link}"
}

resource "google_compute_url_map" "app" {
  name            = "reddit-app-http-loadbalancer"
  description     = "Simple loadbalancer without any path/host matching"
  default_service = "${google_compute_backend_service.app.self_link}"
}

resource "google_compute_instance_group" "appservers" {
  name        = "reddit-appservers"
  description = "Reddit appservers instance group"

  instances = ["${google_compute_instance.app.*.self_link}"]

  named_port {
    name = "reddit-app-http"
    port = "9292"
  }

  zone = "${var.zone}"
}

resource "google_compute_backend_service" "app" {
  name        = "reddit-app-backend"
  port_name   = "reddit-app-http"
  protocol    = "HTTP"
  timeout_sec = 10

  backend {
    group = "${google_compute_instance_group.appservers.self_link}"
  }

  health_checks = ["${google_compute_health_check.app.self_link}"]
}

resource "google_compute_health_check" "app" {
  name               = "http-reddit-app-health-check"
  check_interval_sec = 5
  timeout_sec        = 1

  http_health_check {
    port         = "80"
    request_path = "/"
  }
}

output "lb_app_external_ip" {
  value = "${google_compute_global_forwarding_rule.app.ip_address}"
}
