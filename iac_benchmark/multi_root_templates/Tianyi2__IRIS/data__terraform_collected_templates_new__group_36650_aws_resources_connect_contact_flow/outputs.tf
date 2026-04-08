output "arn" {
  description = "The Amazon Resource Name (ARN) of the Contact Flow."
  value       = aws_connect_contact_flow.this.arn
}

output "id" {
  description = "The identifier of the hosting Amazon Connect Instance and identifier of the Contact Flow separated by a colon (:)."
  value       = aws_connect_contact_flow.this.id
}

output "contact_flow_id" {
  description = "The identifier of the Contact Flow."
  value       = aws_connect_contact_flow.this.contact_flow_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_connect_contact_flow.this.tags_all
}