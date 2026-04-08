resource "aws_location_tracker_association" "this" {
  region       = var.region
  consumer_arn = var.consumer_arn
  tracker_name = var.tracker_name

  timeouts {
    create = var.timeouts_create
    delete = var.timeouts_delete
  }
}