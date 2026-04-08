output "ids" {
  description = "List of all SVM IDs found."
  value       = data.aws_fsx_ontap_storage_virtual_machines.this.ids
}

output "region" {
  description = "The AWS region."
  value       = data.aws_fsx_ontap_storage_virtual_machines.this.region
}

output "filter" {
  description = "The filter configuration used."
  value       = var.filter
}