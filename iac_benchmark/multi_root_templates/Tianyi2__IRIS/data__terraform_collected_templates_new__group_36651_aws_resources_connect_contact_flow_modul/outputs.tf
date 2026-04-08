output "arn" {
  description = "The Amazon Resource Name (ARN) of the Contact Flow Module."
  value       = aws_connect_contact_flow_module.this.arn
}

output "id" {
  description = "The identifier of the hosting Amazon Connect Instance and identifier of the Contact Flow Module separated by a colon (:)."
  value       = aws_connect_contact_flow_module.this.id
}

output "contact_flow_module_id" {
  description = "The identifier of the Contact Flow Module."
  value       = aws_connect_contact_flow_module.this.contact_flow_module_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_connect_contact_flow_module.this.tags_all
}