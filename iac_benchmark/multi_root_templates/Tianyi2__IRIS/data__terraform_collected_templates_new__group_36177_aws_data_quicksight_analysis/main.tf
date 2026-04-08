data "aws_quicksight_analysis" "this" {
  analysis_id    = var.analysis_id
  aws_account_id = var.aws_account_id
  region         = var.region
}