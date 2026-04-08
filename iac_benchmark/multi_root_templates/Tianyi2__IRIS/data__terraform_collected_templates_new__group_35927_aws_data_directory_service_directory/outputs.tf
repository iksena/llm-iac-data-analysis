output "directory_id" {
  description = "ID of the directory"
  value       = data.aws_directory_service_directory.this.directory_id
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_directory_service_directory.this.region
}

output "type" {
  description = "Directory type (SimpleAD, ADConnector or MicrosoftAD)"
  value       = data.aws_directory_service_directory.this.type
}

output "edition" {
  description = "Microsoft AD edition (Standard or Enterprise) - for MicrosoftAD"
  value       = data.aws_directory_service_directory.this.edition
}

output "name" {
  description = "Fully qualified name for the directory/connector"
  value       = data.aws_directory_service_directory.this.name
}


output "size" {
  description = "Size of the directory/connector (Small or Large) - for SimpleAD and ADConnector"
  value       = data.aws_directory_service_directory.this.size
}

output "alias" {
  description = "Alias for the directory/connector"
  value       = data.aws_directory_service_directory.this.alias
}

output "description" {
  description = "Textual description for the directory/connector"
  value       = data.aws_directory_service_directory.this.description
}

output "short_name" {
  description = "Short name of the directory/connector"
  value       = data.aws_directory_service_directory.this.short_name
}

output "enable_sso" {
  description = "Directory/connector single-sign on status"
  value       = data.aws_directory_service_directory.this.enable_sso
}

output "access_url" {
  description = "Access URL for the directory/connector"
  value       = data.aws_directory_service_directory.this.access_url
}

output "dns_ip_addresses" {
  description = "List of IP addresses of the DNS servers for the directory/connector"
  value       = data.aws_directory_service_directory.this.dns_ip_addresses
}

output "security_group_id" {
  description = "ID of the security group created by the directory/connector"
  value       = data.aws_directory_service_directory.this.security_group_id
}

output "tags" {
  description = "A map of tags assigned to the directory/connector"
  value       = data.aws_directory_service_directory.this.tags
}

output "vpc_settings" {
  description = "VPC settings for SimpleAD and MicrosoftAD"
  value       = data.aws_directory_service_directory.this.vpc_settings
}

output "connect_settings" {
  description = "Connect settings for ADConnector"
  value       = data.aws_directory_service_directory.this.connect_settings
}

output "radius_settings" {
  description = "RADIUS settings"
  value       = data.aws_directory_service_directory.this.radius_settings
}