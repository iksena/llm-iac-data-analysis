output "id" {
  description = "DynamoDB resource identifier and key, separated by a comma (,)"
  value       = aws_dynamodb_tag.this.id
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_dynamodb_tag.this.region
}

output "resource_arn" {
  description = "Amazon Resource Name (ARN) of the DynamoDB resource to tag"
  value       = aws_dynamodb_tag.this.resource_arn
}

output "key" {
  description = "Tag name"
  value       = aws_dynamodb_tag.this.key
}

output "value" {
  description = "Tag value"
  value       = aws_dynamodb_tag.this.value
}