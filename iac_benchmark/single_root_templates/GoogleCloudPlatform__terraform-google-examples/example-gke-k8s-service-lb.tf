# ── main.tf ────────────────────────────────────
variable "region" {
  default = "us-west1"
}

variable "zone" {
  default = "us-west1-b"
}

variable "network_name" {
  default = "tf-gke-k8s"
}

provider "google" {
  region = "${var.region}"
}

resource "google_compute_network" "default" {
  name                    = "${var.network_name}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name                     = "${var.network_name}"
  ip_cidr_range            = "10.127.0.0/20"
  network                  = "${google_compute_network.default.self_link}"
  region                   = "${var.region}"
  private_ip_google_access = true
}

data "google_client_config" "current" {}

data "google_container_engine_versions" "default" {
  zone = "${var.zone}"
}

resource "google_container_cluster" "default" {
  name               = "${var.network_name}"
  zone               = "${var.zone}"
  initial_node_count = 3
  min_master_version = "${data.google_container_engine_versions.default.latest_master_version}"
  network            = "${google_compute_subnetwork.default.name}"
  subnetwork         = "${google_compute_subnetwork.default.name}"

  // Use legacy ABAC until these issues are resolved: 
  //   https://github.com/mcuadros/terraform-provider-helm/issues/56
  //   https://github.com/terraform-providers/terraform-provider-kubernetes/pull/73
  enable_legacy_abac = true

  // Wait for the GCE LB controller to cleanup the resources.
  provisioner "local-exec" {
    when    = "destroy"
    command = "sleep 90"
  }
}

output network {
  value = "${google_compute_subnetwork.default.network}"
}

output subnetwork_name {
  value = "${google_compute_subnetwork.default.name}"
}

output cluster_name {
  value = "${google_container_cluster.default.name}"
}

output cluster_region {
  value = "${var.region}"
}

output cluster_zone {
  value = "${google_container_cluster.default.zone}"
}


# ── k8s.tf ────────────────────────────────────
provider "kubernetes" {
  host                   = "${google_container_cluster.default.endpoint}"
  token                  = "${data.google_client_config.current.access_token}"
  client_certificate     = "${base64decode(google_container_cluster.default.master_auth.0.client_certificate)}"
  client_key             = "${base64decode(google_container_cluster.default.master_auth.0.client_key)}"
  cluster_ca_certificate = "${base64decode(google_container_cluster.default.master_auth.0.cluster_ca_certificate)}"
}

resource "kubernetes_namespace" "staging" {
  metadata {
    name = "staging"
  }
}

resource "google_compute_address" "default" {
  name   = "${var.network_name}"
  region = "${var.region}"
}

resource "kubernetes_service" "nginx" {
  metadata {
    namespace = "${kubernetes_namespace.staging.metadata.0.name}"
    name      = "nginx"
  }

  spec {
    selector {
      run = "nginx"
    }

    session_affinity = "ClientIP"

    port {
      protocol    = "TCP"
      port        = 80
      target_port = 80
    }

    type             = "LoadBalancer"
    load_balancer_ip = "${google_compute_address.default.address}"
  }
}

resource "kubernetes_replication_controller" "nginx" {
  metadata {
    name      = "nginx"
    namespace = "${kubernetes_namespace.staging.metadata.0.name}"

    labels {
      run = "nginx"
    }
  }

  spec {
    selector {
      run = "nginx"
    }

    template {
      container {
        image = "nginx:latest"
        name  = "nginx"

        resources {
          limits {
            cpu    = "0.5"
            memory = "512Mi"
          }

          requests {
            cpu    = "250m"
            memory = "50Mi"
          }
        }
      }
    }
  }
}

output "load-balancer-ip" {
  value = "${google_compute_address.default.address}"
}
