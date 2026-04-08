resource "aws_backup_report_plan" "this" {
  name        = var.name
  description = var.description
  region      = var.region

  report_delivery_channel {
    formats        = var.report_delivery_channel_formats
    s3_bucket_name = var.report_delivery_channel_s3_bucket_name
    s3_key_prefix  = var.report_delivery_channel_s3_key_prefix
  }

  report_setting {
    report_template      = var.report_setting_report_template
    accounts             = var.report_setting_accounts
    framework_arns       = var.report_setting_framework_arns
    number_of_frameworks = var.report_setting_number_of_frameworks
    organization_units   = var.report_setting_organization_units
    regions              = var.report_setting_regions
  }

  tags = var.tags
}