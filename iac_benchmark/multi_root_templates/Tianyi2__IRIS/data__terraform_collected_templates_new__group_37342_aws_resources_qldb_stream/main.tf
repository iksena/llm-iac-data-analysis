resource "aws_qldb_stream" "this" {
  region               = var.region
  exclusive_end_time   = var.exclusive_end_time
  inclusive_start_time = var.inclusive_start_time
  ledger_name          = var.ledger_name
  role_arn             = var.role_arn
  stream_name          = var.stream_name
  tags                 = var.tags

  dynamic "kinesis_configuration" {
    for_each = var.kinesis_configuration != null ? [var.kinesis_configuration] : []
    content {
      aggregation_enabled = kinesis_configuration.value.aggregation_enabled
      stream_arn          = kinesis_configuration.value.stream_arn
    }
  }

  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}