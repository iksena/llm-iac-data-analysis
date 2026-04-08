output "id" {
  description = "ID of the instance (matches instance_id)"
  value       = aws_ec2_instance_state.this.id
}

output "instance_id" {
  description = "ID of the instance"
  value       = aws_ec2_instance_state.this.instance_id
}

output "state" {
  description = "State of the instance"
  value       = aws_ec2_instance_state.this.state
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_ec2_instance_state.this.region
}

output "force" {
  description = "Whether to request a forced stop when state is stopped"
  value       = aws_ec2_instance_state.this.force
}