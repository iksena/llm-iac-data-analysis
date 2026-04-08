output "arn" {
  description = "Amazon Resource Name of the file system."
  value       = aws_fsx_ontap_file_system.this.arn
}

output "dns_name" {
  description = "DNS name for the file system. Note: This attribute does not apply to FSx for ONTAP file systems and is consequently not set."
  value       = aws_fsx_ontap_file_system.this.dns_name
}

output "endpoints" {
  description = "The endpoints that are used to access data or to manage the file system using the NetApp ONTAP CLI, REST API, or NetApp SnapMirror."
  value       = aws_fsx_ontap_file_system.this.endpoints
}

output "id" {
  description = "Identifier of the file system, e.g., fs-12345678."
  value       = aws_fsx_ontap_file_system.this.id
}

output "network_interface_ids" {
  description = "Set of Elastic Network Interface identifiers from which the file system is accessible. The first network interface returned is the primary network interface."
  value       = aws_fsx_ontap_file_system.this.network_interface_ids
}

output "owner_id" {
  description = "AWS account identifier that created the file system."
  value       = aws_fsx_ontap_file_system.this.owner_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_fsx_ontap_file_system.this.tags_all
}

output "vpc_id" {
  description = "Identifier of the Virtual Private Cloud for the file system."
  value       = aws_fsx_ontap_file_system.this.vpc_id
}