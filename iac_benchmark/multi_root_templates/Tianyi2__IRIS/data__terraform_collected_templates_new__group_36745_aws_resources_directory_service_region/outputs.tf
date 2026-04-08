output "region" {
  description = "Region where this resource is managed."
  value       = aws_directory_service_region.this.region
}

output "desired_number_of_domain_controllers" {
  description = "The number of domain controllers desired in the replicated directory."
  value       = aws_directory_service_region.this.desired_number_of_domain_controllers
}

output "directory_id" {
  description = "The identifier of the directory to which Region replication was added."
  value       = aws_directory_service_region.this.directory_id
}

output "region_name" {
  description = "The name of the Region where domain controllers for replication were added."
  value       = aws_directory_service_region.this.region_name
}

output "tags" {
  description = "Map of tags assigned to this resource."
  value       = aws_directory_service_region.this.tags
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_directory_service_region.this.tags_all
}

output "vpc_settings" {
  description = "VPC information in the replicated Region."
  value       = aws_directory_service_region.this.vpc_settings
}