output "device_name" {
  description = "The device name exposed to the instance."
  value       = aws_volume_attachment.this.device_name
}

output "instance_id" {
  description = "ID of the Instance."
  value       = aws_volume_attachment.this.instance_id
}

output "volume_id" {
  description = "ID of the Volume."
  value       = aws_volume_attachment.this.volume_id
}