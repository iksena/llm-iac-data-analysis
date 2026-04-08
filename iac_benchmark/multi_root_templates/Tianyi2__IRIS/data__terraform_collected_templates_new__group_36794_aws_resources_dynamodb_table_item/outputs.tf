output "region" {
  description = "Region where this resource is managed"
  value       = aws_dynamodb_table_item.this.region
}

output "hash_key" {
  description = "Hash key used for lookups and identification of the item"
  value       = aws_dynamodb_table_item.this.hash_key
}

output "item" {
  description = "JSON representation of the item attributes"
  value       = aws_dynamodb_table_item.this.item
}

output "range_key" {
  description = "Range key used for lookups and identification of the item"
  value       = aws_dynamodb_table_item.this.range_key
}

output "table_name" {
  description = "Name of the table containing the item"
  value       = aws_dynamodb_table_item.this.table_name
}