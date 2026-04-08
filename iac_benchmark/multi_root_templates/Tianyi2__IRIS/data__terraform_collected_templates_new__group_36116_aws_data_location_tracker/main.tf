data "aws_location_tracker" "this" {
  region       = var.region
  tracker_name = var.tracker_name
}