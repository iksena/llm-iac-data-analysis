data "aws_guardduty_finding_ids" "this" {
  region      = var.region
  detector_id = var.detector_id
}