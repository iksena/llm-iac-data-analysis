output "instance_types" {
  description = "Set of instance types"
  value       = data.aws_outposts_outpost_instance_types.this.instance_types
}

output "arn" {
  description = "Outpost ARN"
  value       = data.aws_outposts_outpost_instance_types.this.arn
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_outposts_outpost_instance_types.this.region
}