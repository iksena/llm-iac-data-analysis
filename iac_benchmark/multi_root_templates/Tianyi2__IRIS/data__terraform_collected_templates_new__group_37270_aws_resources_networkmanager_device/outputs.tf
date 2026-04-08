output "arn" {
  description = "ARN of the device"
  value       = aws_networkmanager_device.this.arn
}

output "id" {
  description = "ID of the device"
  value       = aws_networkmanager_device.this.id
}

output "global_network_id" {
  description = "ID of the global network"
  value       = aws_networkmanager_device.this.global_network_id
}

output "site_id" {
  description = "ID of the site"
  value       = aws_networkmanager_device.this.site_id
}

output "description" {
  description = "Description of the device"
  value       = aws_networkmanager_device.this.description
}

output "model" {
  description = "Model of device"
  value       = aws_networkmanager_device.this.model
}

output "serial_number" {
  description = "Serial number of the device"
  value       = aws_networkmanager_device.this.serial_number
}

output "type" {
  description = "Type of device"
  value       = aws_networkmanager_device.this.type
}

output "vendor" {
  description = "Vendor of the device"
  value       = aws_networkmanager_device.this.vendor
}

output "tags" {
  description = "Key-value tags for the device"
  value       = aws_networkmanager_device.this.tags
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_networkmanager_device.this.tags_all
}

output "aws_location" {
  description = "AWS location of the device"
  value       = aws_networkmanager_device.this.aws_location
}

output "location" {
  description = "Location of the device"
  value       = aws_networkmanager_device.this.location
}