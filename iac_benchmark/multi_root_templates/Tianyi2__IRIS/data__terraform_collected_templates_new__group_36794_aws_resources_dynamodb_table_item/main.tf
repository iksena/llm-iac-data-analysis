resource "aws_dynamodb_table_item" "this" {
  region     = var.region
  hash_key   = var.hash_key
  item       = var.item
  range_key  = var.range_key
  table_name = var.table_name
}