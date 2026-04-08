output "id" {
  description = "ID of the resource."
  value       = aws_lightsail_instance_public_ports.this.id
}

output "instance_name" {
  description = "Name of the instance for which ports are opened."
  value       = aws_lightsail_instance_public_ports.this.instance_name
}

output "port_info" {
  description = "Configuration of the open ports for the instance."
  value       = aws_lightsail_instance_public_ports.this.port_info
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_lightsail_instance_public_ports.this.region
}