output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_datazone_domain.this.region
}

output "name" {
  description = "Name of the Domain."
  value       = data.aws_datazone_domain.this.name
}

output "id" {
  description = "ID of the Domain."
  value       = data.aws_datazone_domain.this.id
}

output "arn" {
  description = "ARN of the Domain."
  value       = data.aws_datazone_domain.this.arn
}

output "created_at" {
  description = "The date and time the Domain was created."
  value       = data.aws_datazone_domain.this.created_at
}

output "description" {
  description = "Description of the Domain."
  value       = data.aws_datazone_domain.this.description
}

output "domain_version" {
  description = "Version of the Domain."
  value       = data.aws_datazone_domain.this.domain_version
}

output "last_updated_at" {
  description = "The date and time the Domain was last updated."
  value       = data.aws_datazone_domain.this.last_updated_at
}

output "managed_account_id" {
  description = "The AWS account ID that owns the Domain."
  value       = data.aws_datazone_domain.this.managed_account_id
}

output "portal_url" {
  description = "URL of the Domain."
  value       = data.aws_datazone_domain.this.portal_url
}

output "status" {
  description = "Status of the Domain."
  value       = data.aws_datazone_domain.this.status
}