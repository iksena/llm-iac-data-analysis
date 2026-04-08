output "arn" {
  description = "Amazon Resource Name (ARN) of the contact channel"
  value       = data.aws_ssmcontacts_contact_channel.this.arn
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_ssmcontacts_contact_channel.this.region
}

output "activation_status" {
  description = "Whether the contact channel is activated"
  value       = data.aws_ssmcontacts_contact_channel.this.activation_status
}

output "contact_id" {
  description = "Amazon Resource Name (ARN) of the AWS SSM Contact that the contact channel belongs to"
  value       = data.aws_ssmcontacts_contact_channel.this.contact_id
}

output "delivery_address" {
  description = "Details used to engage the contact channel"
  value       = data.aws_ssmcontacts_contact_channel.this.delivery_address
}

output "name" {
  description = "Name of the contact channel"
  value       = data.aws_ssmcontacts_contact_channel.this.name
}

output "type" {
  description = "Type of the contact channel"
  value       = data.aws_ssmcontacts_contact_channel.this.type
}