resource "aws_sagemaker_servicecatalog_portfolio_status" "this" {
  region = var.region
  status = var.status
}