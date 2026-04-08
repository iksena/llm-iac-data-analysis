resource "aws_dynamodb_contributor_insights" "this" {
  region     = var.region
  table_name = var.table_name
  index_name = var.index_name
  mode       = var.mode
}