output "arn" {
  description = "Amazon Resource Name of the file system"
  value       = aws_fsx_openzfs_file_system.this.arn
}

output "dns_name" {
  description = "DNS name for the file system"
  value       = aws_fsx_openzfs_file_system.this.dns_name
}

output "endpoint_ip_address" {
  description = "IP address of the endpoint that is used to access data or to manage the file system"
  value       = aws_fsx_openzfs_file_system.this.endpoint_ip_address
}

output "id" {
  description = "Identifier of the file system"
  value       = aws_fsx_openzfs_file_system.this.id
}

output "network_interface_ids" {
  description = "Set of Elastic Network Interface identifiers from which the file system is accessible"
  value       = aws_fsx_openzfs_file_system.this.network_interface_ids
}

output "owner_id" {
  description = "AWS account identifier that created the file system"
  value       = aws_fsx_openzfs_file_system.this.owner_id
}

output "root_volume_id" {
  description = "Identifier of the root volume"
  value       = aws_fsx_openzfs_file_system.this.root_volume_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_fsx_openzfs_file_system.this.tags_all
}

output "vpc_id" {
  description = "Identifier of the Virtual Private Cloud for the file system"
  value       = aws_fsx_openzfs_file_system.this.vpc_id
}