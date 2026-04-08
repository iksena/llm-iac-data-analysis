output "protection_id" {
  description = "Unique identifier for the protection."
  value       = data.aws_shield_protection.this.protection_id
}

output "resource_arn" {
  description = "ARN (Amazon Resource Name) of the resource being protected."
  value       = data.aws_shield_protection.this.resource_arn
}

output "name" {
  description = "Name of the protection."
  value       = data.aws_shield_protection.this.name
}

output "protection_arn" {
  description = "ARN of the protection."
  value       = data.aws_shield_protection.this.protection_arn
}