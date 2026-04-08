locals {
  master_zones = distinct([for i in google_compute_instance.master : i.zone])
}

resource "google_compute_instance" "worker" {
  for_each = { for i in var.workers : i.name => i }

  name         = "${var.deploy_id}-${each.value.name}"
  machine_type = each.value.machine_type
  zone         = each.value.zone

  tags = ["${var.deploy_id}-node", "${var.deploy_id}-worker"]

  metadata = var.ssh_remote_user == "" ? {} : {
    "ssh-keys" = "${var.ssh_remote_user}:${file(var.ssh_public_key)}"
  }

  boot_disk {
    auto_delete = true

    initialize_params {
      size  = 10
      type  = "pd-ssd"
      image = data.google_compute_image.base_image.self_link
    }
  }

  network_interface {
    subnetwork = each.value.subnetwork_id

    access_config {
      network_tier = "STANDARD"
    }
  }

  service_account {
    email  = google_service_account.instance_sa.email
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "master" {
  for_each = { for i in var.masters : i.name => i }

  name         = "${var.deploy_id}-${each.value.name}"
  machine_type = each.value.machine_type
  zone         = each.value.zone

  tags = ["${var.deploy_id}-node", "${var.deploy_id}-master"]

  metadata = var.ssh_remote_user == "" ? {} : {
    "ssh-keys" = "${var.ssh_remote_user}:${file(var.ssh_public_key)}"
  }

  boot_disk {
    auto_delete = true

    initialize_params {
      size  = 10
      type  = "pd-ssd"
      image = data.google_compute_image.base_image.self_link
    }
  }

  network_interface {
    subnetwork = each.value.subnetwork_id

    access_config {
      network_tier = "STANDARD"
    }
  }

  service_account {
    email  = google_service_account.instance_sa.email
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance_group" "master_group" {
  count = length(local.master_zones)

  name        = "${var.deploy_id}-master-instance-group"
  description = "${var.deploy_id} Master Instance Group"

  instances = matchkeys([for i in google_compute_instance.master : i.id], [for i in google_compute_instance.master : i.zone], [local.master_zones[count.index]])

  zone = local.master_zones[count.index]

  named_port {
    name = "http"
    port = 80
  }

  named_port {
    name = "https"
    port = 6443
  }
}

resource "google_compute_forwarding_rule" "load_balancer" {
  name            = "${var.deploy_id}-forwarding-rule"
  region          = var.region
  port_range      = 6443
  backend_service = google_compute_region_backend_service.control_plane.id
}

resource "google_compute_region_backend_service" "control_plane" {
  name                  = "${var.deploy_id}-control-plane-lb"
  region                = var.region
  load_balancing_scheme = "EXTERNAL"
  health_checks         = [google_compute_region_health_check.control_plane_hc.id]

  backend {
    group          = google_compute_instance_group.master_group[0].id
    balancing_mode = "CONNECTION"
  }
}

resource "google_compute_region_health_check" "control_plane_hc" {
  name               = "${var.deploy_id}-control-plane-health-check"
  check_interval_sec = 5
  timeout_sec        = 5
  region             = var.region

  http_health_check {
    port_name          = "https"
    port_specification = "USE_NAMED_PORT"
    request_path       = "/readyz"
    host               = "kubernetes.default.svc.cluster.local"
  }
}

output "external_cluster_ip" {
  value = google_compute_forwarding_rule.load_balancer.ip_address
}
