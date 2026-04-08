data "aws_ec2_network_insights_analysis" "this" {
  region                       = var.region
  network_insights_analysis_id = var.network_insights_analysis_id

  dynamic "filter" {
    for_each = var.filter != null ? var.filter : []
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}