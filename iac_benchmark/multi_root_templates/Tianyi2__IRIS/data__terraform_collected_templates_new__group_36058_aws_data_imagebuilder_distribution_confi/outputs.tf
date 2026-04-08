output "arns" {
  description = "Set of ARNs of the matched Image Builder Distribution Configurations"
  value       = data.aws_imagebuilder_distribution_configurations.this.arns
}

output "names" {
  description = "Set of names of the matched Image Builder Distribution Configurations"
  value       = data.aws_imagebuilder_distribution_configurations.this.names
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_imagebuilder_distribution_configurations.this.region
}