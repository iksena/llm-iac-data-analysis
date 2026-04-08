output "arns" {
  description = "Set of Load Balancer ARNs."
  value       = data.aws_lbs.this.arns
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_lbs.this.region
}

output "tags" {
  description = "Map of tags used to filter the Load Balancers."
  value       = data.aws_lbs.this.tags
}