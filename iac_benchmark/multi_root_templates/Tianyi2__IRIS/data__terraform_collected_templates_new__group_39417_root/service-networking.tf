resource "google_project_service" "service-networking" {
  service                    = "servicenetworking.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

/*
See https://github.com/hashicorp/terraform-provider-google/issues/21931

This api is broken in the Google provider.
To get around this, attempt to create the google_service_networking_connection below first.
It will fail with a permissions error because the google_project_iam_member hasn't been created yet.
Once it fails, the google_project_service_identity will be created and we can continue.
https://cloud.google.com/vpc/docs/configure-private-services-access#service_account_permissions
*/
resource "google_project_service_identity" "service-networking" {
  provider = google-beta

  project = local.project_id
  service = "servicenetworking.googleapis.com"

  depends_on = [google_project_service.service-networking]
}

// There is an eventual consistency issue with creation of the service networking identity
resource "time_sleep" "wait_for_service_networking_identity" {
  create_duration = "10s"
  depends_on      = [google_project_service_identity.service-networking]
}

resource "google_project_iam_member" "service_networking_service_agent" {
  project = local.project_id
  role    = "roles/servicenetworking.serviceAgent"
  member  = "serviceAccount:service-${local.project_number}@service-networking.iam.gserviceaccount.com"

  depends_on = [time_sleep.wait_for_service_networking_identity]
}

resource "google_compute_global_address" "gcp_private" {
  name          = "${local.resource_name}-private-ip-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.this.id
}

locals {
  private_service_cidr = "${google_compute_global_address.gcp_private.address}/${google_compute_global_address.gcp_private.prefix_length}"
}

// There are 2 outstanding issue related to destroying this resource
// - https://github.com/hashicorp/terraform-provider-google/issues/19908
// - https://github.com/hashicorp/terraform-provider-google/issues/18834
//
// If this fails, follow these steps:
// 1. Go to the VPC network in Google Cloud console
// 2. Switch to VPC NETWORK PEERING tab
// 3. Select "servicenetworking-googleapis.com" and click DELETE
// 4. Run a destroy on the network
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.this.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.gcp_private.name]

  depends_on = [google_project_iam_member.service_networking_service_agent]
}
