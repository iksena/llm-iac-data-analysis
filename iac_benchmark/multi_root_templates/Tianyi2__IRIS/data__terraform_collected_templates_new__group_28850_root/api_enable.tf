# Enable Required Google Cloud APIs
resource "google_project_service" "apis" {
  for_each = toset(local.apis_to_enable)
  project  = local.gcp_project_id
  service  = each.value
}
