resource "aws_cloudwatch_log_anomaly_detector" "this" {
  enabled                 = var.enabled
  region                  = var.region
  log_group_arn_list      = var.log_group_arn_list
  anomaly_visibility_time = var.anomaly_visibility_time
  detector_name           = var.detector_name
  evaluation_frequency    = var.evaluation_frequency
  filter_pattern          = var.filter_pattern
  kms_key_id              = var.kms_key_id
}