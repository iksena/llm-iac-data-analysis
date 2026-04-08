output "arn" {
  description = "ARN of the infrastructure configuration"
  value       = data.aws_imagebuilder_infrastructure_configuration.this.arn
}

output "region" {
  description = "Region where this resource will be managed"
  value       = data.aws_imagebuilder_infrastructure_configuration.this.region
}

output "date_created" {
  description = "Date the infrastructure configuration was created"
  value       = data.aws_imagebuilder_infrastructure_configuration.this.date_created
}

output "date_updated" {
  description = "Date the infrastructure configuration was updated"
  value       = data.aws_imagebuilder_infrastructure_configuration.this.date_updated
}

output "description" {
  description = "Description of the infrastructure configuration"
  value       = data.aws_imagebuilder_infrastructure_configuration.this.description
}

output "instance_metadata_options" {
  description = "Nested list of instance metadata options for the HTTP requests that pipeline builds use to launch EC2 build and test instances"
  value       = data.aws_imagebuilder_infrastructure_configuration.this.instance_metadata_options
}

output "instance_profile_name" {
  description = "Name of the IAM Instance Profile associated with the configuration"
  value       = data.aws_imagebuilder_infrastructure_configuration.this.instance_profile_name
}

output "instance_types" {
  description = "Set of EC2 Instance Types associated with the configuration"
  value       = data.aws_imagebuilder_infrastructure_configuration.this.instance_types
}

output "key_pair" {
  description = "Name of the EC2 Key Pair associated with the configuration"
  value       = data.aws_imagebuilder_infrastructure_configuration.this.key_pair
}

output "logging" {
  description = "Nested list of logging settings"
  value       = data.aws_imagebuilder_infrastructure_configuration.this.logging
}

output "name" {
  description = "Name of the infrastructure configuration"
  value       = data.aws_imagebuilder_infrastructure_configuration.this.name
}

output "placement" {
  description = "Placement settings that define where the instances that are launched from your image will run"
  value       = data.aws_imagebuilder_infrastructure_configuration.this.placement
}

output "resource_tags" {
  description = "Key-value map of resource tags for the infrastructure created by the infrastructure configuration"
  value       = data.aws_imagebuilder_infrastructure_configuration.this.resource_tags
}

output "security_group_ids" {
  description = "Set of EC2 Security Group identifiers associated with the configuration"
  value       = data.aws_imagebuilder_infrastructure_configuration.this.security_group_ids
}

output "sns_topic_arn" {
  description = "ARN of the SNS Topic associated with the configuration"
  value       = data.aws_imagebuilder_infrastructure_configuration.this.sns_topic_arn
}

output "subnet_id" {
  description = "Identifier of the EC2 Subnet associated with the configuration"
  value       = data.aws_imagebuilder_infrastructure_configuration.this.subnet_id
}

output "tags" {
  description = "Key-value map of resource tags for the infrastructure configuration"
  value       = data.aws_imagebuilder_infrastructure_configuration.this.tags
}

output "terminate_instance_on_failure" {
  description = "Whether instances are terminated on failure"
  value       = data.aws_imagebuilder_infrastructure_configuration.this.terminate_instance_on_failure
}