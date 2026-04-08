resource "aws_sagemaker_device_fleet" "this" {
  region                = var.region
  device_fleet_name     = var.device_fleet_name
  role_arn              = var.role_arn
  description           = var.description
  enable_iot_role_alias = var.enable_iot_role_alias
  tags                  = var.tags

  output_config {
    s3_output_location = var.output_config.s3_output_location
    kms_key_id         = var.output_config.kms_key_id
  }
}