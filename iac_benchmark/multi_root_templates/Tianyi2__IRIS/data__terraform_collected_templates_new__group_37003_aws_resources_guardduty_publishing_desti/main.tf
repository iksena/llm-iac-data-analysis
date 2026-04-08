resource "aws_guardduty_publishing_destination" "this" {
  detector_id      = var.detector_id
  destination_arn  = var.destination_arn
  kms_key_arn      = var.kms_key_arn
  destination_type = var.destination_type
  region           = var.region
}