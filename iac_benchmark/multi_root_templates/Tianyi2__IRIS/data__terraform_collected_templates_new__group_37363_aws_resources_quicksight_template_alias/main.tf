resource "aws_quicksight_template_alias" "this" {
  alias_name              = var.alias_name
  template_id             = var.template_id
  template_version_number = var.template_version_number
  aws_account_id          = var.aws_account_id
  region                  = var.region
}