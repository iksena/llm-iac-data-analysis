output "contact_flow_id" {
  description = "Contact flow ID"
  value       = aws_connect_phone_number_contact_flow_association.this.contact_flow_id
}

output "instance_id" {
  description = "Amazon Connect instance ID"
  value       = aws_connect_phone_number_contact_flow_association.this.instance_id
}

output "phone_number_id" {
  description = "Phone number ID"
  value       = aws_connect_phone_number_contact_flow_association.this.phone_number_id
}