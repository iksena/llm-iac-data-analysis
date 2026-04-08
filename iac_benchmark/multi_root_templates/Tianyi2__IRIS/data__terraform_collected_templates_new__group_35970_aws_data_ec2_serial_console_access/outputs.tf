output "enabled" {
  description = "Whether or not serial console access is enabled. Returns as true or false."
  value       = data.aws_ec2_serial_console_access.this.enabled
}

output "id" {
  description = "Region of serial console access."
  value       = data.aws_ec2_serial_console_access.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_ec2_serial_console_access.this.region
}