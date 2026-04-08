output "arn" {
  description = "ARN of the listener"
  value       = data.aws_vpclattice_listener.this.arn
}

output "created_at" {
  description = "The date and time that the listener was created"
  value       = data.aws_vpclattice_listener.this.created_at
}

output "default_action" {
  description = "The actions for the default listener rule"
  value       = data.aws_vpclattice_listener.this.default_action
}

output "last_updated_at" {
  description = "The date and time the listener was last updated"
  value       = data.aws_vpclattice_listener.this.last_updated_at
}

output "listener_id" {
  description = "The ID of the listener"
  value       = data.aws_vpclattice_listener.this.listener_id
}

output "name" {
  description = "The name of the listener"
  value       = data.aws_vpclattice_listener.this.name
}

output "port" {
  description = "The listener port"
  value       = data.aws_vpclattice_listener.this.port
}

output "protocol" {
  description = "The listener protocol. Either HTTPS or HTTP"
  value       = data.aws_vpclattice_listener.this.protocol
}

output "service_arn" {
  description = "The ARN of the service"
  value       = data.aws_vpclattice_listener.this.service_arn
}

output "service_id" {
  description = "The ID of the service"
  value       = data.aws_vpclattice_listener.this.service_id
}

output "tags" {
  description = "List of tags associated with the listener"
  value       = data.aws_vpclattice_listener.this.tags
}