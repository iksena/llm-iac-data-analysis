output "arn" {
  description = "The Amazon Resource Name (ARN) of the rotation."
  value       = data.aws_ssmcontacts_rotation.this.arn
}

output "contact_ids" {
  description = "The Amazon Resource Names (ARNs) of the contacts to add to the rotation. The order in which you list the contacts is their shift order in the rotation schedule."
  value       = data.aws_ssmcontacts_rotation.this.contact_ids
}

output "name" {
  description = "The name for the rotation."
  value       = data.aws_ssmcontacts_rotation.this.name
}

output "time_zone_id" {
  description = "The time zone to base the rotation's activity on in Internet Assigned Numbers Authority (IANA) format."
  value       = data.aws_ssmcontacts_rotation.this.time_zone_id
}

output "recurrence" {
  description = "Information about when an on-call rotation is in effect and how long the rotation period lasts."
  value       = data.aws_ssmcontacts_rotation.this.recurrence
}

output "start_time" {
  description = "The date and time, in RFC 3339 format, that the rotation goes into effect."
  value       = data.aws_ssmcontacts_rotation.this.start_time
}

output "tags" {
  description = "A map of tags to assign to the resource."
  value       = data.aws_ssmcontacts_rotation.this.tags
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_ssmcontacts_rotation.this.region
}