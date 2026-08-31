locals {
  common_tags = {
    Module      = "cloudtrail"
    Environment = "infra"
    ManagedBy   = "aws-cld"
    Project     = var.project
  }

  cloudtrail_name              = "${var.project}-main-cloudtrail"
  cloudtrail_access_log_bucket = "${var.project}-cloudtrail-access-log"
  cloudwatch_log_group_name    = "${var.project}-cloudtrail"
}
