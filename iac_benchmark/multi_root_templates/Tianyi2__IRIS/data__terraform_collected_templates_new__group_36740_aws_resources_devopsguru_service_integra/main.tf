resource "aws_devopsguru_service_integration" "this" {
  region = var.region

  kms_server_side_encryption {
    kms_key_id    = var.kms_server_side_encryption.kms_key_id
    opt_in_status = var.kms_server_side_encryption.opt_in_status
    type          = var.kms_server_side_encryption.type
  }

  logs_anomaly_detection {
    opt_in_status = var.logs_anomaly_detection.opt_in_status
  }

  ops_center {
    opt_in_status = var.ops_center.opt_in_status
  }
}