data "aws_ec2_network_insights_path" "this" {
  region                   = var.region
  network_insights_path_id = var.network_insights_path_id

  dynamic "filter" {
    for_each = var.filter
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}