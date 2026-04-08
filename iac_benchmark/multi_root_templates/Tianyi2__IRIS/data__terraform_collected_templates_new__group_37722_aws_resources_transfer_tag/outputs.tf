output "id" {
  description = "Transfer Family resource identifier and key, separated by a comma (`,`)"
  value       = aws_transfer_tag.this.id
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_transfer_tag.this.region
}

output "resource_arn" {
  description = "Amazon Resource Name (ARN) of the Transfer Family resource"
  value       = aws_transfer_tag.this.resource_arn
}

output "key" {
  description = "Tag name"
  value       = aws_transfer_tag.this.key
}

output "value" {
  description = "Tag value"
  value       = aws_transfer_tag.this.value
}