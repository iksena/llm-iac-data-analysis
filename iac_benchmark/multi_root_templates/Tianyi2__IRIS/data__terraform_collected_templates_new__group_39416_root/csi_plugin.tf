resource "google_project_iam_custom_role" "csi_role" {
  role_id     = "io.kubernetes.${var.deploy_id}.csi"
  title       = "Kubernetes CSI Plugin Role"
  description = "Allow CSI Plugin Role"
  permissions = ["compute.instances.get", "compute.instances.attachDisk", "compute.instances.detachDisk"]
}

resource "google_service_account" "csi_plugin_sa" {
  account_id   = "csi-plugin-${var.deploy_id}"
  display_name = "Service Account for Kubernetes CSI Plugin"
  description  = "Allow Kubernetes CSI Plugin connection with GCE"
}

locals {
  csi_roles = ["roles/iam.serviceAccountUser", "roles/compute.storageAdmin", google_project_iam_custom_role.csi_role.name]
}

resource "google_project_iam_member" "csi_project_iam_member" {
  count = length(local.csi_roles)

  project = var.project_id
  role    = local.csi_roles[count.index]
  member  = "serviceAccount:${google_service_account.csi_plugin_sa.email}"

  depends_on = [
    google_project_iam_custom_role.csi_role
  ]
}

resource "google_service_account_key" "json_key" {
  service_account_id = google_service_account.csi_plugin_sa.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "local_file" "csi_json_key" {
  content  = base64decode(google_service_account_key.json_key.private_key)
  filename = "${path.cwd}/cloud-sa.json"
}
