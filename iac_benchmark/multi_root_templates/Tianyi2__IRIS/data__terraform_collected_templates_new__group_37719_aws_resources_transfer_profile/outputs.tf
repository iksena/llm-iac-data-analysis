output "arn" {
  description = "The ARN of the profile"
  value       = aws_transfer_profile.this.arn
}

output "profile_id" {
  description = "The unique identifier for the AS2 profile"
  value       = aws_transfer_profile.this.profile_id
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_transfer_profile.this.region
}

output "as2_id" {
  description = "The As2Id is the AS2 name as defined in the RFC 4130"
  value       = aws_transfer_profile.this.as2_id
}

output "certificate_ids" {
  description = "The list of certificate Ids from the imported certificate operation"
  value       = aws_transfer_profile.this.certificate_ids
}

output "profile_type" {
  description = "The profile type LOCAL or PARTNER"
  value       = aws_transfer_profile.this.profile_type
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = aws_transfer_profile.this.tags
}