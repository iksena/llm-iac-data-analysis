output "contact_id" {
  description = "The Amazon Resource Name (ARN) of the contact or escalation plan"
  value       = data.aws_ssmcontacts_plan.this.contact_id
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_ssmcontacts_plan.this.region
}

output "stage" {
  description = "List of stages. A contact has an engagement plan with stages that contact specified contact channels. An escalation plan uses stages that contact specified contacts"
  value       = data.aws_ssmcontacts_plan.this.stage
}