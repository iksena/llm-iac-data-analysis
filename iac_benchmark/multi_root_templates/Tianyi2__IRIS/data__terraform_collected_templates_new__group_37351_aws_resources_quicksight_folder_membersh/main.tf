resource "aws_quicksight_folder_membership" "this" {
  aws_account_id = var.aws_account_id
  folder_id      = var.folder_id
  member_id      = var.member_id
  member_type    = var.member_type
  region         = var.region
}