output "id" {
  description = "Identifier of the Service Catalog Tag Option"
  value       = aws_servicecatalog_tag_option.this.id
}


output "key" {
  description = "Tag option key"
  value       = aws_servicecatalog_tag_option.this.key
}

output "value" {
  description = "Tag option value"
  value       = aws_servicecatalog_tag_option.this.value
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_servicecatalog_tag_option.this.region
}

output "active" {
  description = "Whether tag option is active"
  value       = aws_servicecatalog_tag_option.this.active
}