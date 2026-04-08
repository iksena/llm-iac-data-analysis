output "item" {
  description = "JSON representation of a map of attribute names to AttributeValue objects, as specified by ProjectionExpression"
  value       = data.aws_dynamodb_table_item.this.item
}

output "table_name" {
  description = "The name of the table containing the requested item"
  value       = data.aws_dynamodb_table_item.this.table_name
}

output "key" {
  description = "A map of attribute names to AttributeValue objects, representing the primary key of the item to retrieve"
  value       = data.aws_dynamodb_table_item.this.key
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_dynamodb_table_item.this.region
}

output "expression_attribute_names" {
  description = "Substitution tokens for attribute names in an expression"
  value       = data.aws_dynamodb_table_item.this.expression_attribute_names
}

output "projection_expression" {
  description = "String that identifies one or more attributes to retrieve from the table"
  value       = data.aws_dynamodb_table_item.this.projection_expression
}