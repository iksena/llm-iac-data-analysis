output "supported_instance_types" {
  description = "List of supported instance types"
  value       = data.aws_emr_supported_instance_types.this.supported_instance_types
}

output "architecture" {
  description = "CPU architecture for each supported instance type"
  value       = data.aws_emr_supported_instance_types.this.supported_instance_types[*].architecture
}

output "ebs_optimized_available" {
  description = "Indicates whether each instance type supports Amazon EBS optimization"
  value       = data.aws_emr_supported_instance_types.this.supported_instance_types[*].ebs_optimized_available
}

output "ebs_optimized_by_default" {
  description = "Indicates whether each instance type uses Amazon EBS optimization by default"
  value       = data.aws_emr_supported_instance_types.this.supported_instance_types[*].ebs_optimized_by_default
}

output "ebs_storage_only" {
  description = "Indicates whether each instance type only supports Amazon EBS"
  value       = data.aws_emr_supported_instance_types.this.supported_instance_types[*].ebs_storage_only
}

output "instance_family_id" {
  description = "The Amazon EC2 family and generation for each instance type"
  value       = data.aws_emr_supported_instance_types.this.supported_instance_types[*].instance_family_id
}

output "is_64_bits_only" {
  description = "Indicates whether each instance type only supports 64-bit architecture"
  value       = data.aws_emr_supported_instance_types.this.supported_instance_types[*].is_64_bits_only
}

output "memory_gb" {
  description = "Memory that is available to Amazon EMR from each instance type"
  value       = data.aws_emr_supported_instance_types.this.supported_instance_types[*].memory_gb
}

output "number_of_disks" {
  description = "Number of disks for each instance type"
  value       = data.aws_emr_supported_instance_types.this.supported_instance_types[*].number_of_disks
}

output "storage_gb" {
  description = "Storage capacity of each instance type"
  value       = data.aws_emr_supported_instance_types.this.supported_instance_types[*].storage_gb
}

output "type" {
  description = "Amazon EC2 instance types (e.g., m5.xlarge)"
  value       = data.aws_emr_supported_instance_types.this.supported_instance_types[*].type
}

output "vcpu" {
  description = "The number of vCPUs available for each instance type"
  value       = data.aws_emr_supported_instance_types.this.supported_instance_types[*].vcpu
}