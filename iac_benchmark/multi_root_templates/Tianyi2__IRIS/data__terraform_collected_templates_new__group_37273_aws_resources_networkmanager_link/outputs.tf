output "arn" {
  description = "Link ARN"
  value       = aws_networkmanager_link.this.arn
}

output "bandwidth" {
  description = "Upload speed and download speed in Mbps"
  value       = aws_networkmanager_link.this.bandwidth
}

output "description" {
  description = "Description of the link"
  value       = aws_networkmanager_link.this.description
}

output "global_network_id" {
  description = "ID of the global network"
  value       = aws_networkmanager_link.this.global_network_id
}

output "provider_name" {
  description = "Provider of the link"
  value       = aws_networkmanager_link.this.provider_name
}

output "site_id" {
  description = "ID of the site"
  value       = aws_networkmanager_link.this.site_id
}

output "tags" {
  description = "Key-value tags for the link"
  value       = aws_networkmanager_link.this.tags
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_networkmanager_link.this.tags_all
}

output "type" {
  description = "Type of the link"
  value       = aws_networkmanager_link.this.type
}