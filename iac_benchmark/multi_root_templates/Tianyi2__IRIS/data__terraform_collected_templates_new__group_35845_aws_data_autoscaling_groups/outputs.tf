output "arns" {
  description = "List of the Autoscaling Groups Arns in the current region"
  value       = data.aws_autoscaling_groups.this.arns
}

output "id" {
  description = "AWS Region"
  value       = data.aws_autoscaling_groups.this.id
}

output "names" {
  description = "List of the Autoscaling Groups in the current region"
  value       = data.aws_autoscaling_groups.this.names
}