output "arn" {
  description = "Amazon Resource Name of the storage virtual machine."
  value       = aws_fsx_ontap_storage_virtual_machine.this.arn
}

output "id" {
  description = "Identifier of the storage virtual machine, e.g., svm-12345678"
  value       = aws_fsx_ontap_storage_virtual_machine.this.id
}

output "subtype" {
  description = "Describes the SVM's subtype, e.g. DEFAULT"
  value       = aws_fsx_ontap_storage_virtual_machine.this.subtype
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_fsx_ontap_storage_virtual_machine.this.tags_all
}

output "uuid" {
  description = "The SVM's UUID (universally unique identifier)."
  value       = aws_fsx_ontap_storage_virtual_machine.this.uuid
}

output "endpoints" {
  description = "The endpoints that are used to access data or to manage the storage virtual machine using the NetApp ONTAP CLI, REST API, or NetApp SnapMirror."
  value       = aws_fsx_ontap_storage_virtual_machine.this.endpoints
}

output "endpoints_iscsi" {
  description = "An endpoint for accessing data on your storage virtual machine via iSCSI protocol."
  value       = try(aws_fsx_ontap_storage_virtual_machine.this.endpoints[0].iscsi, null)
}

output "endpoints_management" {
  description = "An endpoint for managing your file system using the NetApp ONTAP CLI and NetApp ONTAP API."
  value       = try(aws_fsx_ontap_storage_virtual_machine.this.endpoints[0].management, null)
}

output "endpoints_nfs" {
  description = "An endpoint for accessing data on your storage virtual machine via NFS protocol."
  value       = try(aws_fsx_ontap_storage_virtual_machine.this.endpoints[0].nfs, null)
}

output "endpoints_smb" {
  description = "An endpoint for accessing data on your storage virtual machine via SMB protocol. This is only set if an active_directory_configuration has been set."
  value       = try(aws_fsx_ontap_storage_virtual_machine.this.endpoints[0].smb, null)
}

output "endpoints_iscsi_dns_name" {
  description = "The Domain Name Service (DNS) name for the iSCSI endpoint."
  value       = try(aws_fsx_ontap_storage_virtual_machine.this.endpoints[0].iscsi[0].dns_name, null)
}

output "endpoints_iscsi_ip_addresses" {
  description = "IP addresses of the iSCSI endpoint."
  value       = try(aws_fsx_ontap_storage_virtual_machine.this.endpoints[0].iscsi[0].ip_addresses, null)
}

output "endpoints_management_dns_name" {
  description = "The Domain Name Service (DNS) name for the management endpoint."
  value       = try(aws_fsx_ontap_storage_virtual_machine.this.endpoints[0].management[0].dns_name, null)
}

output "endpoints_management_ip_addresses" {
  description = "IP addresses of the management endpoint."
  value       = try(aws_fsx_ontap_storage_virtual_machine.this.endpoints[0].management[0].ip_addresses, null)
}

output "endpoints_nfs_dns_name" {
  description = "The Domain Name Service (DNS) name for the NFS endpoint."
  value       = try(aws_fsx_ontap_storage_virtual_machine.this.endpoints[0].nfs[0].dns_name, null)
}

output "endpoints_nfs_ip_addresses" {
  description = "IP addresses of the NFS endpoint."
  value       = try(aws_fsx_ontap_storage_virtual_machine.this.endpoints[0].nfs[0].ip_addresses, null)
}

output "endpoints_smb_dns_name" {
  description = "The Domain Name Service (DNS) name for the SMB endpoint."
  value       = try(aws_fsx_ontap_storage_virtual_machine.this.endpoints[0].smb[0].dns_name, null)
}

output "endpoints_smb_ip_addresses" {
  description = "IP addresses of the SMB endpoint."
  value       = try(aws_fsx_ontap_storage_virtual_machine.this.endpoints[0].smb[0].ip_addresses, null)
}