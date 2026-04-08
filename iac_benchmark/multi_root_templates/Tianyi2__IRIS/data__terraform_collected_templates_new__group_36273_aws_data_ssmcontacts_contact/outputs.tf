output "arn" {
  description = "The Amazon Resource Name (ARN) of the contact or escalation plan."
  value       = data.aws_ssmcontacts_contact.this.arn
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_ssmcontacts_contact.this.region
}

output "alias" {
  description = "A unique and identifiable alias of the contact or escalation plan."
  value       = data.aws_ssmcontacts_contact.this.alias
}

output "type" {
  description = "The type of contact engaged. A single contact is type PERSONAL and an escalation plan is type ESCALATION."
  value       = data.aws_ssmcontacts_contact.this.type
}

output "display_name" {
  description = "Full friendly name of the contact or escalation plan."
  value       = data.aws_ssmcontacts_contact.this.display_name
}

output "tags" {
  description = "Map of tags assigned to the resource."
  value       = data.aws_ssmcontacts_contact.this.tags
}