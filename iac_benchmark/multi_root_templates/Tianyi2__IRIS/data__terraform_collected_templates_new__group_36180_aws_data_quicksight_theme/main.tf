data "aws_quicksight_theme" "this" {
  theme_id       = var.theme_id
  aws_account_id = var.aws_account_id
  region         = var.region
}