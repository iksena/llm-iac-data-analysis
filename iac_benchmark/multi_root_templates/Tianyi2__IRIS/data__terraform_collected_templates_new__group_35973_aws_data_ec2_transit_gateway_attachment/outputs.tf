output "arn" {
  description = "ARN of the attachment."
  value       = data.aws_ec2_transit_gateway_attachment.this.arn
}

output "association_state" {
  description = "The state of the association."
  value       = data.aws_ec2_transit_gateway_attachment.this.association_state
}

output "association_transit_gateway_route_table_id" {
  description = "The ID of the route table for the transit gateway."
  value       = data.aws_ec2_transit_gateway_attachment.this.association_transit_gateway_route_table_id
}

output "resource_id" {
  description = "ID of the resource."
  value       = data.aws_ec2_transit_gateway_attachment.this.resource_id
}

output "resource_owner_id" {
  description = "ID of the AWS account that owns the resource."
  value       = data.aws_ec2_transit_gateway_attachment.this.resource_owner_id
}

output "resource_type" {
  description = "Resource type."
  value       = data.aws_ec2_transit_gateway_attachment.this.resource_type
}

output "state" {
  description = "Attachment state."
  value       = data.aws_ec2_transit_gateway_attachment.this.state
}

output "tags" {
  description = "Key-value tags for the attachment."
  value       = data.aws_ec2_transit_gateway_attachment.this.tags
}

output "transit_gateway_id" {
  description = "ID of the transit gateway."
  value       = data.aws_ec2_transit_gateway_attachment.this.transit_gateway_id
}

output "transit_gateway_owner_id" {
  description = "The ID of the AWS account that owns the transit gateway."
  value       = data.aws_ec2_transit_gateway_attachment.this.transit_gateway_owner_id
}