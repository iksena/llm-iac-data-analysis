output "arn" {
  description = "Amazon Resource Name of the file system."
  value       = aws_fsx_windows_file_system.this.arn
}

output "dns_name" {
  description = "DNS name for the file system, e.g., fs-12345678.corp.example.com (domain name matching the Active Directory domain name)."
  value       = aws_fsx_windows_file_system.this.dns_name
}

output "id" {
  description = "Identifier of the file system (e.g. fs-12345678)."
  value       = aws_fsx_windows_file_system.this.id
}

output "network_interface_ids" {
  description = "Set of Elastic Network Interface identifiers from which the file system is accessible."
  value       = aws_fsx_windows_file_system.this.network_interface_ids
}

output "owner_id" {
  description = "AWS account identifier that created the file system."
  value       = aws_fsx_windows_file_system.this.owner_id
}

output "preferred_file_server_ip" {
  description = "The IP address of the primary, or preferred, file server."
  value       = aws_fsx_windows_file_system.this.preferred_file_server_ip
}

output "remote_administration_endpoint" {
  description = "For MULTI_AZ_1 deployment types, use this endpoint when performing administrative tasks on the file system using Amazon FSx Remote PowerShell. For SINGLE_AZ_1 deployment types, this is the DNS name of the file system."
  value       = aws_fsx_windows_file_system.this.remote_administration_endpoint
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_fsx_windows_file_system.this.tags_all
}

output "vpc_id" {
  description = "Identifier of the Virtual Private Cloud for the file system."
  value       = aws_fsx_windows_file_system.this.vpc_id
}