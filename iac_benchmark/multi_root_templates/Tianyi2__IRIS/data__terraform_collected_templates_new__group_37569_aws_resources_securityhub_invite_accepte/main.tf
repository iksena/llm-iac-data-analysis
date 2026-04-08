resource "aws_securityhub_invite_accepter" "this" {
  region    = var.region
  master_id = var.master_id
}