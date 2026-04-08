output "portworx_backup_name" {
  value       = ibm_resource_instance.portworx_backup.name
  description = "Portworx Backup Name - IBM Catalog"
}

output "portworx_backup_state" {
  value       = ibm_resource_instance.portworx_backup.state
  description = "Portworx Backup State - IBM Catalog"
}