output "arn" {
  description = "ARN of the listener"
  value       = aws_vpclattice_listener.this.arn
}

output "created_at" {
  description = "Date and time that the listener was created, specified in ISO-8601 format"
  value       = aws_vpclattice_listener.this.created_at
}

output "listener_id" {
  description = "Standalone ID of the listener"
  value       = aws_vpclattice_listener.this.listener_id
}


output "region" {
  description = "Region where the listener is managed"
  value       = aws_vpclattice_listener.this.region
}

output "name" {
  description = "Name of the listener"
  value       = aws_vpclattice_listener.this.name
}

output "port" {
  description = "Listener port"
  value       = aws_vpclattice_listener.this.port
}

output "protocol" {
  description = "Protocol for the listener"
  value       = aws_vpclattice_listener.this.protocol
}

output "service_arn" {
  description = "Amazon Resource Name (ARN) of the VPC Lattice service"
  value       = aws_vpclattice_listener.this.service_arn
}

output "service_identifier" {
  description = "ID of the VPC Lattice service"
  value       = aws_vpclattice_listener.this.service_identifier
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = aws_vpclattice_listener.this.tags
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_vpclattice_listener.this.tags_all
}