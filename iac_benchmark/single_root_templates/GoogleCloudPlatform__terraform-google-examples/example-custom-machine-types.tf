# ── main.tf ────────────────────────────────────
provider "google" {
  region = "${var.region}"
}

data "google_project" "current" {}

data "google_compute_default_service_account" "default" {}

resource "google_compute_network" "default" {
  name                    = "${var.network_name}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name                     = "${var.network_name}"
  ip_cidr_range            = "${var.network_cidr}"
  network                  = "${google_compute_network.default.self_link}"
  region                   = "${var.region}"
  private_ip_google_access = true
}

resource "google_compute_instance" "default" {
  count                     = "${var.num_nodes}"
  name                      = "${var.name}-${count.index + 1}"
  zone                      = "${var.zone}"
  tags                      = ["${concat(list("${var.name}-ssh", "${var.name}"), var.node_tags)}"]
  machine_type              = "${var.machine_type}"
  min_cpu_platform          = "${var.min_cpu_platform}"
  allow_stopping_for_update = true

  boot_disk {
    auto_delete = "${var.disk_auto_delete}"

    initialize_params {
      image = "${var.image_project}/${var.image_family}"
      size  = "${var.disk_size_gb}"
      type  = "${var.disk_type}"
    }
  }

  network_interface {
    subnetwork    = "${google_compute_subnetwork.default.name}"
    access_config = ["${var.access_config}"]
    address       = "${var.network_ip}"
  }

  metadata = "${merge(
    map("startup-script", "${var.startup_script}", "tf_depends_id", "${var.depends_id}"),
    var.metadata
  )}"

  service_account {
    email  = "${var.service_account_email == "" ? data.google_compute_default_service_account.default.email : var.service_account_email }"
    scopes = ["${var.service_account_scopes}"]
  }
}

resource "google_compute_firewall" "ssh" {
  name    = "${var.name}-ssh"
  network = "${google_compute_subnetwork.default.name}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_tags = ["${var.name}-bastion"]
  target_tags = ["${var.name}-ssh"]
}

// Bastion host
data "google_compute_image" "bastion" {
  family  = "${var.bastion_image_family}"
  project = "${var.bastion_image_project == "" ? data.google_project.current.project_id : var.bastion_image_project}"
}

module "bastion" {
  source             = "GoogleCloudPlatform/managed-instance-group/google"
  version            = "1.1.14"
  region             = "${var.region}"
  zone               = "${var.zone}"
  network            = "${google_compute_subnetwork.default.name}"
  subnetwork         = "${google_compute_subnetwork.default.name}"
  target_tags        = ["${var.name}-bastion"]
  machine_type       = "${var.bastion_machine_type}"
  name               = "${var.name}-bastion"
  compute_image      = "${data.google_compute_image.bastion.self_link}"
  http_health_check  = false
  service_port       = "80"
  service_port_name  = "http"
  wait_for_instances = true
}

// NAT gateway
module "nat-gateway" {
  source     = "GoogleCloudPlatform/nat-gateway/google"
  version    = "1.2.0"
  region     = "${var.region}"
  zone       = "${var.zone}"
  network    = "${google_compute_subnetwork.default.name}"
  subnetwork = "${google_compute_subnetwork.default.name}"
  tags       = ["${var.name}"]
}

output "bastion_instance" {
  value = "${element(module.bastion.instances[0], 0)}"
}

output "bastion" {
  value = "gcloud compute ssh --ssh-flag=\"-A\" $(terraform output bastion_instance)"
}


# ── variables.tf ────────────────────────────────────
variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-b"
}

variable "network_cidr" {
  default = "10.127.0.0/20"
}

variable "network_name" {
  default = "tf-custom-machine"
}

variable "machine_type" {
  description = "In the form of custom-CPUS-MEM, number of CPUs and memory for custom machine. https://cloud.google.com/compute/docs/instances/creating-instance-with-custom-machine-type#specifications"
  default     = "custom-6-65536-ext"
}

variable "min_cpu_platform" {
  description = "Specifies a minimum CPU platform for the VM instance. Applicable values are the friendly names of CPU platforms, such as Intel Haswell or Intel Skylake. https://cloud.google.com/compute/docs/instances/specify-min-cpu-platform"
  default     = "Automatic"
}

variable "name" {
  description = "Name prefix for the nodes"
  default     = "tf-custom"
}

variable "num_nodes" {
  description = "Number of nodes to create"
  default     = 1
}

variable "image_family" {
  default = "centos-7"
}

variable "image_project" {
  default = "centos-cloud"
}

variable "disk_auto_delete" {
  description = "Whether or not the disk should be auto-deleted."
  default     = true
}

variable "disk_type" {
  description = "The GCE disk type. Can be either pd-ssd, local-ssd, or pd-standard."
  default     = "pd-ssd"
}

variable "disk_size_gb" {
  description = "The size of the image in gigabytes."
  default     = 10
}

variable "access_config" {
  description = "The access config block for the instances. Set to [{}] for ephemeral external IP."
  type        = "list"
  default     = []
}

variable "network_ip" {
  description = "Set the network IP of the instance. Useful only when num_nodes is equal to 1."
  default     = ""
}

variable "node_tags" {
  description = "Additional compute instance network tags for the nodes."
  type        = "list"
  default     = []
}

variable "startup_script" {
  description = "Content of startup-script metadata passed to the instance template."
  default     = ":"
}

variable "metadata" {
  description = "Map of metadata values to pass to instances."
  type        = "map"
  default     = {}
}

variable "depends_id" {
  description = "The ID of a resource that the instance group depends on."
  default     = ""
}

variable "service_account_email" {
  description = "The email of the service account for the instance template."
  default     = ""
}

variable "service_account_scopes" {
  description = "List of scopes for the instance template service account"
  type        = "list"

  default = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring.write",
    "https://www.googleapis.com/auth/devstorage.full_control",
  ]
}

// Bastion host
variable "bastion_image_family" {
  default = "centos-7"
}

variable "bastion_image_project" {
  default = "centos-cloud"
}

variable "bastion_machine_type" {
  default = "n1-standard-1"
}
