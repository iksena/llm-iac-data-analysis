output "id" {
  description = "Outpost identifier"
  value       = data.aws_outposts_outpost_instance_type.this.id
}

output "arn" {
  description = "Outpost ARN"
  value       = data.aws_outposts_outpost_instance_type.this.arn
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_outposts_outpost_instance_type.this.region
}

output "instance_type" {
  description = "Instance type returned by the data source"
  value       = data.aws_outposts_outpost_instance_type.this.instance_type
}

output "preferred_instance_types" {
  description = "Ordered list of preferred instance types"
  value       = data.aws_outposts_outpost_instance_type.this.preferred_instance_types
}