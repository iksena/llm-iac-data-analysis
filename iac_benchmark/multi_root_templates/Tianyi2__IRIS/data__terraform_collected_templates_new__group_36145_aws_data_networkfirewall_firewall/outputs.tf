output "arn" {
  description = "ARN of the firewall."
  value       = data.aws_networkfirewall_firewall.this.arn
}

output "availability_zone_change_protection" {
  description = "Indicates whether the firewall is protected against changes to its Availability Zone configuration."
  value       = data.aws_networkfirewall_firewall.this.availability_zone_change_protection
}

output "availability_zone_mapping" {
  description = "Set of Availability Zones where the firewall endpoints are created for a transit gateway-attached firewall."
  value       = data.aws_networkfirewall_firewall.this.availability_zone_mapping
}

output "delete_protection" {
  description = "A flag indicating whether the firewall is protected against deletion."
  value       = data.aws_networkfirewall_firewall.this.delete_protection
}

output "description" {
  description = "Description of the firewall."
  value       = data.aws_networkfirewall_firewall.this.description
}

output "enabled_analysis_types" {
  description = "Set of types for which to collect analysis metrics."
  value       = data.aws_networkfirewall_firewall.this.enabled_analysis_types
}

output "encryption_configuration" {
  description = "AWS Key Management Service (AWS KMS) encryption settings for the firewall."
  value       = data.aws_networkfirewall_firewall.this.encryption_configuration
}

output "firewall_policy_arn" {
  description = "ARN of the VPC Firewall policy."
  value       = data.aws_networkfirewall_firewall.this.firewall_policy_arn
}

output "firewall_policy_change_protection" {
  description = "A flag indicating whether the firewall is protected against a change to the firewall policy association."
  value       = data.aws_networkfirewall_firewall.this.firewall_policy_change_protection
}

output "firewall_status" {
  description = "Nested list of information about the current status of the firewall."
  value       = data.aws_networkfirewall_firewall.this.firewall_status
}

output "id" {
  description = "ARN that identifies the firewall."
  value       = data.aws_networkfirewall_firewall.this.id
}

output "name" {
  description = "Descriptive name of the firewall."
  value       = data.aws_networkfirewall_firewall.this.name
}

output "subnet_change_protection" {
  description = "A flag indicating whether the firewall is protected against changes to the subnet associations."
  value       = data.aws_networkfirewall_firewall.this.subnet_change_protection
}

output "subnet_mapping" {
  description = "Set of configuration blocks describing the public subnets. Each subnet must belong to a different Availability Zone in the VPC. AWS Network Firewall creates a firewall endpoint in each subnet."
  value       = data.aws_networkfirewall_firewall.this.subnet_mapping
}

output "tags" {
  description = "Map of resource tags to associate with the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  value       = data.aws_networkfirewall_firewall.this.tags
}

output "update_token" {
  description = "String token used when updating a firewall."
  value       = data.aws_networkfirewall_firewall.this.update_token
}

output "transit_gateway_id" {
  description = "The unique identifier of the transit gateway associated with this firewall."
  value       = data.aws_networkfirewall_firewall.this.transit_gateway_id
}

output "transit_gateway_owner_account_id" {
  description = "The AWS account ID that owns the transit gateway."
  value       = data.aws_networkfirewall_firewall.this.transit_gateway_owner_account_id
}

output "vpc_id" {
  description = "Unique identifier of the VPC where AWS Network Firewall should create the firewall."
  value       = data.aws_networkfirewall_firewall.this.vpc_id
}