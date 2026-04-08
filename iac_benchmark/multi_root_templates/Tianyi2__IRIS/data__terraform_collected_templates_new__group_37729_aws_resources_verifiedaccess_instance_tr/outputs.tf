output "id" {
  description = "A combination of attributes, separated by a `/` to create a unique id: verifiedaccess_instance_id,verifiedaccess_trust_provider_id"
  value       = aws_verifiedaccess_instance_trust_provider_attachment.this.id
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_verifiedaccess_instance_trust_provider_attachment.this.region
}

output "verifiedaccess_instance_id" {
  description = "The ID of the Verified Access instance"
  value       = aws_verifiedaccess_instance_trust_provider_attachment.this.verifiedaccess_instance_id
}

output "verifiedaccess_trust_provider_id" {
  description = "The ID of the Verified Access trust provider"
  value       = aws_verifiedaccess_instance_trust_provider_attachment.this.verifiedaccess_trust_provider_id
}