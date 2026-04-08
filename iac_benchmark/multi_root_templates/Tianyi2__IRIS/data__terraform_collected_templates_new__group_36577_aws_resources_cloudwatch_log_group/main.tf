resource "aws_cloudwatch_log_group" "this" {
  region            = var.region
  name              = var.name
  name_prefix       = var.name_prefix
  skip_destroy      = var.skip_destroy
  log_group_class   = var.log_group_class
  retention_in_days = var.retention_in_days
  kms_key_id        = var.kms_key_id
  tags              = var.tags
}