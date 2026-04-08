resource "aws_macie2_invitation_accepter" "this" {
  administrator_account_id = var.administrator_account_id
  region                   = var.region
}