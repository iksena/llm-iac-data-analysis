output "arn" {
  description = "ARN of the Profile"
  value       = aws_route53profiles_profile.this.arn
}

output "id" {
  description = "ID of the Profile"
  value       = aws_route53profiles_profile.this.id
}

output "name" {
  description = "Name of the Profile"
  value       = aws_route53profiles_profile.this.name
}

output "share_status" {
  description = "Share status of the Profile"
  value       = aws_route53profiles_profile.this.share_status
}

output "status" {
  description = "Status of the Profile"
  value       = aws_route53profiles_profile.this.status
}

output "status_message" {
  description = "Status message of the Profile"
  value       = aws_route53profiles_profile.this.status_message
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_route53profiles_profile.this.tags_all
}