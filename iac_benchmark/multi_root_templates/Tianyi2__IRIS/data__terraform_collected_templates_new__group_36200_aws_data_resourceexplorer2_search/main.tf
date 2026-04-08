data "aws_resourceexplorer2_search" "this" {
  query_string = var.query_string
  region       = var.region
  view_arn     = var.view_arn
}