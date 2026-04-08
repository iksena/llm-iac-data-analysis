output "arn" {
  description = "Site ARN"
  value       = aws_networkmanager_site.this.arn
}

output "global_network_id" {
  description = "ID of the Global Network"
  value       = aws_networkmanager_site.this.global_network_id
}

output "description" {
  description = "Description of the Site"
  value       = aws_networkmanager_site.this.description
}

output "location" {
  description = "Site location"
  value       = aws_networkmanager_site.this.location
}

output "tags" {
  description = "Key-value tags for the Site"
  value       = aws_networkmanager_site.this.tags
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_networkmanager_site.this.tags_all
}