resource "aws_guardduty_member_detector_feature" "this" {
  region      = var.region
  detector_id = var.detector_id
  account_id  = var.account_id
  name        = var.name
  status      = var.status

  dynamic "additional_configuration" {
    for_each = var.additional_configuration != null ? [var.additional_configuration] : []
    content {
      name   = additional_configuration.value.name
      status = additional_configuration.value.status
    }
  }
}