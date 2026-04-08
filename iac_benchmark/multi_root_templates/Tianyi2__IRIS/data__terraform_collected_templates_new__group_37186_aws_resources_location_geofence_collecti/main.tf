resource "aws_location_geofence_collection" "this" {
  collection_name = var.collection_name
  region          = var.region
  description     = var.description
  kms_key_id      = var.kms_key_id
  tags            = var.tags

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}