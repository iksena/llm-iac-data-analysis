output "names" {
  description = "A list of all the DynamoDB table names found."
  value       = data.aws_dynamodb_tables.this.names
}