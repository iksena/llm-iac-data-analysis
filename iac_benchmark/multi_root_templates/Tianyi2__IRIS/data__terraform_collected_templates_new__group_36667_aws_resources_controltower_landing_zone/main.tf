resource "aws_controltower_landing_zone" "this" {
  region        = var.region
  manifest_json = var.manifest_json
  version       = var.landing_zone_version
  tags          = var.tags

  timeouts {
    create = var.timeout_create
    update = var.timeout_update
    delete = var.timeout_delete
  }
}