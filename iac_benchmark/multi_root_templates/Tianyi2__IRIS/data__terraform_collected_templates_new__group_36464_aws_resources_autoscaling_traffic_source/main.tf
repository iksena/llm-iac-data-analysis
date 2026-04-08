resource "aws_autoscaling_traffic_source_attachment" "this" {
  region                 = var.region
  autoscaling_group_name = var.autoscaling_group_name

  traffic_source {
    identifier = var.traffic_source.identifier
    type       = var.traffic_source.type
  }
}