output "id" {
  description = "Name of the contact list"
  value       = aws_sesv2_contact_list.this.id
}

output "created_timestamp" {
  description = "Timestamp noting when the contact list was created in ISO 8601 format"
  value       = aws_sesv2_contact_list.this.created_timestamp
}

output "last_updated_timestamp" {
  description = "Timestamp noting the last time the contact list was updated in ISO 8601 format"
  value       = aws_sesv2_contact_list.this.last_updated_timestamp
}

output "contact_list_name" {
  description = "Name of the contact list"
  value       = aws_sesv2_contact_list.this.contact_list_name
}

output "description" {
  description = "Description of what the contact list is about"
  value       = aws_sesv2_contact_list.this.description
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_sesv2_contact_list.this.region
}

output "tags" {
  description = "Key-value map of resource tags for the contact list"
  value       = aws_sesv2_contact_list.this.tags
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_sesv2_contact_list.this.tags_all
}