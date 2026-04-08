output "identifier" {
  description = "DB Instance Identifier"
  value       = aws_rds_instance_state.this.identifier
}

output "state" {
  description = "Configured state of the DB Instance"
  value       = aws_rds_instance_state.this.state
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_rds_instance_state.this.region
}