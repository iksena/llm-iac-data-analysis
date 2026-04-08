# Service Account
resource "google_service_account" "service_account" {
  account_id   = local.service_account_display_name
  display_name = local.service_account_display_name
  project      = local.gcp_project_id
}
