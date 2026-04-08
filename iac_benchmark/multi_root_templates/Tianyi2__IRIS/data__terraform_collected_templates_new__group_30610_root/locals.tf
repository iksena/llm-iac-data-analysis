locals {
  cw_log_group_name           = "/aws/kinesisfirehose/${var.name}"
  cw_log_delivery_stream_name = "DestinationDelivery"
  cw_log_backup_stream_name   = "BackupDelivery"
  backup_modes = {
    elasticsearch : {
      FailedOnly : "FailedDocumentsOnly",
      All : "AllDocuments"
    }
    splunk : {
      FailedOnly : "FailedEventsOnly",
      All : "AllEvents"
    }
    http_endpoint : {
      FailedOnly : "FailedDataOnly",
      All : "AllData"
    }
    extended_s3 : {
      FailedOnly : "Enabled",
      All : "Enabled"
    }
    redshift : {
      FailedOnly : "Enabled",
      All : "Enabled"
    }
    opensearch : {
      FailedOnly : "FailedDocumentsOnly",
      All : "AllDocuments"
    }
  }
  s3_backup_mode = var.s3_backup_enable ? local.backup_modes[var.destination][var.s3_backup_mode] : null

  s3_backup_cw_log_group_name  = var.destination_cw_log_create ? local.cw_log_group_name : var.s3_backup_cw_log_group_name
  s3_backup_cw_log_stream_name = var.destination_cw_log_create ? local.cw_log_backup_stream_name : var.s3_backup_cw_log_stream_name

  # Destination Log
  destination_cw_log_group_name  = var.destination_cw_log_create ? local.cw_log_group_name : var.destination_cw_log_group_name
  destination_cw_log_stream_name = var.destination_cw_log_create ? local.cw_log_delivery_stream_name : var.destination_cw_log_stream_name

  # Cloudwatch
  create_destination_logs = var.create && var.destination_cw_log_enable && var.destination_cw_log_create
  create_backup_logs      = var.create && var.s3_backup_enable && var.s3_backup_cw_log_enable && var.s3_backup_cw_log_create
}
