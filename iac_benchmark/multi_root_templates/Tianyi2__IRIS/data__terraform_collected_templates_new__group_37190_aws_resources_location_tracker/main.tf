resource "aws_location_tracker" "this" {
  tracker_name       = var.tracker_name
  region             = var.region
  description        = var.description
  kms_key_id         = var.kms_key_id
  position_filtering = var.position_filtering
  tags               = var.tags
}