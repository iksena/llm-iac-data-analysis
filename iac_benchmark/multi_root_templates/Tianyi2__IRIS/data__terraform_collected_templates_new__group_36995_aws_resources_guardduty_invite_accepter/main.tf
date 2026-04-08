resource "aws_guardduty_invite_accepter" "this" {
  region            = var.region
  detector_id       = var.detector_id
  master_account_id = var.master_account_id

  timeouts {
    create = var.timeouts_create
  }
}