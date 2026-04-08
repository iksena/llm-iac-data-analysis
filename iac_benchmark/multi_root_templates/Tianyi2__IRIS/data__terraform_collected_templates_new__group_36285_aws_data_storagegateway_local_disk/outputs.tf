output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_storagegateway_local_disk.this.region
}

output "gateway_arn" {
  description = "ARN of the gateway."
  value       = data.aws_storagegateway_local_disk.this.gateway_arn
}

output "disk_node" {
  description = "Device node of the local disk."
  value       = data.aws_storagegateway_local_disk.this.disk_node
}

output "disk_path" {
  description = "Device path of the local disk."
  value       = data.aws_storagegateway_local_disk.this.disk_path
}

output "disk_id" {
  description = "Disk identifier. E.g., pci-0000:03:00.0-scsi-0:0:0:0"
  value       = data.aws_storagegateway_local_disk.this.disk_id
}

output "id" {
  description = "Disk identifier. E.g., pci-0000:03:00.0-scsi-0:0:0:0"
  value       = data.aws_storagegateway_local_disk.this.id
}