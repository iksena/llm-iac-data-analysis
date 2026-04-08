output "arn" {
  description = "The Amazon Resource Name (ARN) of the Quick Connect"
  value       = aws_connect_quick_connect.this.arn
}

output "quick_connect_id" {
  description = "The identifier for the Quick Connect"
  value       = aws_connect_quick_connect.this.quick_connect_id
}

output "id" {
  description = "The identifier of the hosting Amazon Connect Instance and identifier of the Quick Connect separated by a colon (:)"
  value       = aws_connect_quick_connect.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_connect_quick_connect.this.tags_all
}