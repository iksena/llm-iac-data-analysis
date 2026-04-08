resource "google_logging_project_sink" "cloud_ai_police_sink" {
  name        = local.log_sink.name
  destination = local.log_sink.destination
  filter      = local.log_sink.filter
  project     = local.gcp_project_id
  depends_on = [ google_project_service.apis ]
}