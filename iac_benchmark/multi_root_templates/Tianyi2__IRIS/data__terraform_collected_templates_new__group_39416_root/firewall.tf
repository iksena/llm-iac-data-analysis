resource "google_compute_firewall" "allow_iap_ssh" {
  count = var.allow_ssh_from_iap ? 1 : 0

  name    = "${var.deploy_id}-fwr-allow-ssh-iap"
  network = var.network_id

  allow {
    ports    = ["22"]
    protocol = "tcp"
  }

  source_ranges = ["35.235.240.0/20"] # As seen on: https://cloud.google.com/iap/docs/using-tcp-forwarding
  target_tags   = ["${var.deploy_id}-node"]
}

resource "google_compute_firewall" "allow_intra_node_network" {
  name    = "${var.deploy_id}-fwr-allow-intra-node"
  network = var.network_id

  allow {
    protocol = "all"
  }

  source_tags = ["${var.deploy_id}-node"]
  target_tags = ["${var.deploy_id}-node"]
}

resource "google_compute_firewall" "allow_anywhere_ssh" {
  count = var.allow_ssh_from_anywhere ? 1 : 0

  name    = "${var.deploy_id}-fwr-allow-ssh-anywhere"
  network = var.network_id

  allow {
    ports    = ["22"]
    protocol = "tcp"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.deploy_id}-node"]
}

resource "google_compute_firewall" "allow_kube_api_access" {
  name    = "${var.deploy_id}-fwr-allow-kubeapi-access"
  network = var.network_id

  allow {
    ports    = ["6443", "80"]
    protocol = "tcp"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.deploy_id}-master"]
}
