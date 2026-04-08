resource "aws_flow_log" "this" {
  region                        = var.region
  traffic_type                  = var.traffic_type
  deliver_cross_account_role    = var.deliver_cross_account_role
  eni_id                        = var.eni_id
  iam_role_arn                  = var.iam_role_arn
  log_destination_type          = var.log_destination_type
  log_destination               = var.log_destination
  subnet_id                     = var.subnet_id
  transit_gateway_id            = var.transit_gateway_id
  transit_gateway_attachment_id = var.transit_gateway_attachment_id
  vpc_id                        = var.vpc_id
  log_format                    = var.log_format
  max_aggregation_interval      = var.max_aggregation_interval
  tags                          = var.tags

  dynamic "destination_options" {
    for_each = var.destination_options != null ? [var.destination_options] : []
    content {
      file_format                = destination_options.value.file_format
      hive_compatible_partitions = destination_options.value.hive_compatible_partitions
      per_hour_partition         = destination_options.value.per_hour_partition
    }
  }
}