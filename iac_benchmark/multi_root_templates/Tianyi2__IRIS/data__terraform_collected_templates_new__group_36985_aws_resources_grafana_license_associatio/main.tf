resource "aws_grafana_license_association" "this" {
  region        = var.region
  grafana_token = var.grafana_token
  license_type  = var.license_type
  workspace_id  = var.workspace_id
}