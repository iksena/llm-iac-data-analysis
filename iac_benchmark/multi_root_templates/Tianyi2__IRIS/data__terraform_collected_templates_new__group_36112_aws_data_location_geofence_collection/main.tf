data "aws_location_geofence_collection" "this" {
  region          = var.region
  collection_name = var.collection_name
}