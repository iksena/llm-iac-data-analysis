data "aws_quicksight_data_set" "this" {
  aws_account_id = var.aws_account_id
  data_set_id    = var.data_set_id
  region         = var.region
}