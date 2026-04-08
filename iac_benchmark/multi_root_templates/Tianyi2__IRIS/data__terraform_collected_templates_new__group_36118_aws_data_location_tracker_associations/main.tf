data "aws_location_tracker_associations" "this" {
  region       = var.region
  tracker_name = var.tracker_name
}