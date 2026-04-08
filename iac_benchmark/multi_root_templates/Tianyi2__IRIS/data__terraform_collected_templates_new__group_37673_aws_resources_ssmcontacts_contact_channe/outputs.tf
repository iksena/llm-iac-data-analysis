output "activation_status" {
  description = "Whether the contact channel is activated. The contact channel must be activated to use it to engage the contact. One of ACTIVATED or NOT_ACTIVATED"
  value       = aws_ssmcontacts_contact_channel.this.activation_status
}

output "arn" {
  description = "Amazon Resource Name (ARN) of the contact channel"
  value       = aws_ssmcontacts_contact_channel.this.arn
}