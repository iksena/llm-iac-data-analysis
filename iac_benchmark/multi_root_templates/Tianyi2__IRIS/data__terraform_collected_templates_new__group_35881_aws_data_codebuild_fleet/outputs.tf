output "arn" {
  description = "ARN of the Fleet."
  value       = data.aws_codebuild_fleet.this.arn
}

output "base_capacity" {
  description = "Number of machines allocated to the ﬂeet."
  value       = data.aws_codebuild_fleet.this.base_capacity
}

output "compute_configuration" {
  description = "Compute configuration of the compute fleet."
  value       = data.aws_codebuild_fleet.this.compute_configuration
}

output "compute_type" {
  description = "Compute resources the compute fleet uses."
  value       = data.aws_codebuild_fleet.this.compute_type
}

output "created" {
  description = "Creation time of the fleet."
  value       = data.aws_codebuild_fleet.this.created
}

output "environment_type" {
  description = "Environment type of the compute fleet."
  value       = data.aws_codebuild_fleet.this.environment_type
}

output "fleet_service_role" {
  description = "The service role associated with the compute fleet."
  value       = data.aws_codebuild_fleet.this.fleet_service_role
}

output "id" {
  description = "ARN of the Fleet."
  value       = data.aws_codebuild_fleet.this.id
}

output "image_id" {
  description = "The Amazon Machine Image (AMI) of the compute fleet."
  value       = data.aws_codebuild_fleet.this.image_id
}

output "last_modified" {
  description = "Last modification time of the fleet."
  value       = data.aws_codebuild_fleet.this.last_modified
}

output "name" {
  description = "Fleet name."
  value       = data.aws_codebuild_fleet.this.name
}

output "overflow_behavior" {
  description = "Overflow behavior for compute fleet."
  value       = data.aws_codebuild_fleet.this.overflow_behavior
}

output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_codebuild_fleet.this.region
}

output "scaling_configuration" {
  description = "Nested attribute containing information about the scaling configuration."
  value       = data.aws_codebuild_fleet.this.scaling_configuration
}

output "status" {
  description = "Nested attribute containing information about the current status of the fleet."
  value       = data.aws_codebuild_fleet.this.status
}

output "tags" {
  description = "Mapping of Key-Value tags for the resource."
  value       = data.aws_codebuild_fleet.this.tags
}

output "vpc_config" {
  description = "Nested attribute containing information about the VPC configuration."
  value       = data.aws_codebuild_fleet.this.vpc_config
}