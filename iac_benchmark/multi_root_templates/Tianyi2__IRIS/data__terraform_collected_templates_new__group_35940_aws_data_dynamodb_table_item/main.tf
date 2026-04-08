data "aws_dynamodb_table_item" "this" {
  table_name                 = var.table_name
  key                        = var.key
  region                     = var.region
  expression_attribute_names = var.expression_attribute_names
  projection_expression      = var.projection_expression
}