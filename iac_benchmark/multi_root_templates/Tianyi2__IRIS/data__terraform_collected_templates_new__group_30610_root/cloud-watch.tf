resource "aws_cloudwatch_log_group" "log" {
  count             = local.create_destination_logs || local.create_backup_logs ? 1 : 0
  name              = local.cw_log_group_name
  retention_in_days = var.cw_log_retention_in_days
  tags              = var.tags
}

resource "aws_cloudwatch_log_stream" "backup" {
  count          = local.create_backup_logs ? 1 : 0
  name           = local.cw_log_backup_stream_name
  log_group_name = aws_cloudwatch_log_group.log[0].name
}

resource "aws_cloudwatch_log_stream" "destination" {
  count          = local.create_destination_logs ? 1 : 0
  name           = local.destination_cw_log_stream_name
  log_group_name = aws_cloudwatch_log_group.log[0].name
}
