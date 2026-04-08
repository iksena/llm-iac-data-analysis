output "alternative_domain_names" {
  description = "Alternate domain names of the distribution"
  value       = aws_lightsail_distribution.this.alternative_domain_names
}

output "arn" {
  description = "ARN of the distribution"
  value       = aws_lightsail_distribution.this.arn
}

output "created_at" {
  description = "Timestamp when the distribution was created"
  value       = aws_lightsail_distribution.this.created_at
}

output "domain_name" {
  description = "Domain name of the distribution"
  value       = aws_lightsail_distribution.this.domain_name
}

output "location" {
  description = "Location of the distribution, such as the AWS Region and Availability Zone"
  value       = aws_lightsail_distribution.this.location
}

output "origin_public_dns" {
  description = "Public DNS of the origin"
  value       = aws_lightsail_distribution.this.origin_public_dns
}

output "origin_resource_type" {
  description = "Resource type of the origin resource (e.g., Instance)"
  value       = try(aws_lightsail_distribution.this.origin[0].resource_type, null)
}

output "resource_type" {
  description = "Lightsail resource type (e.g., Distribution)"
  value       = aws_lightsail_distribution.this.resource_type
}

output "status" {
  description = "Status of the distribution"
  value       = aws_lightsail_distribution.this.status
}

output "support_code" {
  description = "Support code for Lightsail support team"
  value       = aws_lightsail_distribution.this.support_code
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_lightsail_distribution.this.tags_all
}

output "location_availability_zone" {
  description = "Availability Zone of the distribution location"
  value       = try(aws_lightsail_distribution.this.location[0].availability_zone, null)
}

output "location_region_name" {
  description = "AWS Region name of the distribution location"
  value       = try(aws_lightsail_distribution.this.location[0].region_name, null)
}