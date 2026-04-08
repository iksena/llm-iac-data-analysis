resource "aws_inspector2_member_association" "this" {
  account_id = var.account_id
  region     = var.region
}