output "id" {
  description = "The directory identifier"
  value       = aws_directory_service_directory.this.id
}

output "access_url" {
  description = "The access URL for the directory, such as http://alias.awsapps.com"
  value       = aws_directory_service_directory.this.access_url
}

output "dns_ip_addresses" {
  description = "A list of IP addresses of the DNS servers for the directory or connector"
  value       = aws_directory_service_directory.this.dns_ip_addresses
}

output "security_group_id" {
  description = "The ID of the security group created by the directory"
  value       = aws_directory_service_directory.this.security_group_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_directory_service_directory.this.tags_all
}

output "connect_settings" {
  description = "Connect settings with additional exported attributes (for ADConnector)"
  value = var.connect_settings != null ? {
    customer_username = aws_directory_service_directory.this.connect_settings[0].customer_username
    customer_dns_ips  = aws_directory_service_directory.this.connect_settings[0].customer_dns_ips
    subnet_ids        = aws_directory_service_directory.this.connect_settings[0].subnet_ids
    vpc_id            = aws_directory_service_directory.this.connect_settings[0].vpc_id
    connect_ips       = aws_directory_service_directory.this.connect_settings[0].connect_ips
  } : null
}

output "name" {
  description = "The fully qualified name for the directory"
  value       = aws_directory_service_directory.this.name
}

output "password" {
  description = "The password for the directory administrator or connector user"
  value       = aws_directory_service_directory.this.password
  sensitive   = true
}

output "size" {
  description = "The size of the directory"
  value       = aws_directory_service_directory.this.size
}

output "alias" {
  description = "The alias for the directory"
  value       = aws_directory_service_directory.this.alias
}

output "description" {
  description = "A textual description for the directory"
  value       = aws_directory_service_directory.this.description
}

output "desired_number_of_domain_controllers" {
  description = "The number of domain controllers desired in the directory"
  value       = aws_directory_service_directory.this.desired_number_of_domain_controllers
}

output "short_name" {
  description = "The short name of the directory"
  value       = aws_directory_service_directory.this.short_name
}

output "enable_sso" {
  description = "Whether single-sign on is enabled for the directory"
  value       = aws_directory_service_directory.this.enable_sso
}

output "type" {
  description = "The directory type"
  value       = aws_directory_service_directory.this.type
}

output "edition" {
  description = "The MicrosoftAD edition"
  value       = aws_directory_service_directory.this.edition
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = aws_directory_service_directory.this.tags
}

output "vpc_settings" {
  description = "VPC related information about the directory"
  value = var.vpc_settings != null ? {
    subnet_ids = aws_directory_service_directory.this.vpc_settings[0].subnet_ids
    vpc_id     = aws_directory_service_directory.this.vpc_settings[0].vpc_id
  } : null
}