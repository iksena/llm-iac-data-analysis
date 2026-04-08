output "arn" {
  description = "Amazon Resource Name of the SVM."
  value       = data.aws_fsx_ontap_storage_virtual_machine.this.arn
}

output "active_directory_configuration" {
  description = "The Microsoft Active Directory configuration to which the SVM is joined, if applicable."
  value       = data.aws_fsx_ontap_storage_virtual_machine.this.active_directory_configuration
}

output "creation_time" {
  description = "The time that the SVM was created."
  value       = data.aws_fsx_ontap_storage_virtual_machine.this.creation_time
}

output "endpoints" {
  description = "The endpoints that are used to access data or to manage the SVM using the NetApp ONTAP CLI, REST API, or NetApp CloudManager."
  value       = data.aws_fsx_ontap_storage_virtual_machine.this.endpoints
}

output "file_system_id" {
  description = "Identifier of the file system (e.g. fs-12345678)."
  value       = data.aws_fsx_ontap_storage_virtual_machine.this.file_system_id
}

output "id" {
  description = "The SVM's system generated unique ID."
  value       = data.aws_fsx_ontap_storage_virtual_machine.this.id
}

output "lifecycle_status" {
  description = "The SVM's lifecycle status."
  value       = data.aws_fsx_ontap_storage_virtual_machine.this.lifecycle_status
}

output "lifecycle_transition_reason" {
  description = "Describes why the SVM lifecycle state changed."
  value       = data.aws_fsx_ontap_storage_virtual_machine.this.lifecycle_transition_reason
}

output "name" {
  description = "The name of the SVM, if provisioned."
  value       = data.aws_fsx_ontap_storage_virtual_machine.this.name
}

output "subtype" {
  description = "The SVM's subtype."
  value       = data.aws_fsx_ontap_storage_virtual_machine.this.subtype
}

output "uuid" {
  description = "The SVM's UUID."
  value       = data.aws_fsx_ontap_storage_virtual_machine.this.uuid
}