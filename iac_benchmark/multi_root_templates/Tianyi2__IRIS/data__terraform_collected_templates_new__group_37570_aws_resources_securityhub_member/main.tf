resource "aws_securityhub_member" "this" {
  region     = var.region
  account_id = var.account_id
  email      = var.email
  invite     = var.invite
}