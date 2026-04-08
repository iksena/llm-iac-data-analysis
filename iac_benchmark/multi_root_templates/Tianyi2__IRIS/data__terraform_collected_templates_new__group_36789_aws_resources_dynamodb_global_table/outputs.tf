output "id" {
  description = "The name of the DynamoDB Global Table"
  value       = aws_dynamodb_global_table.this.id
}

output "arn" {
  description = "The ARN of the DynamoDB Global Table"
  value       = aws_dynamodb_global_table.this.arn
}