output "id" {
  description = "The identifier of the landing zone."
  value       = aws_controltower_landing_zone.this.id
}

output "arn" {
  description = "The ARN of the landing zone."
  value       = aws_controltower_landing_zone.this.arn
}

output "drift_status" {
  description = "The drift status summary of the landing zone."
  value       = aws_controltower_landing_zone.this.drift_status
}

output "drift_status_status" {
  description = "The drift status of the landing zone."
  value       = try(aws_controltower_landing_zone.this.drift_status.status, null)
}

output "latest_available_version" {
  description = "The latest available version of the landing zone."
  value       = aws_controltower_landing_zone.this.latest_available_version
}

output "tags_all" {
  description = "A map of tags assigned to the landing zone, including those inherited from the provider default_tags configuration block."
  value       = aws_controltower_landing_zone.this.tags_all
}