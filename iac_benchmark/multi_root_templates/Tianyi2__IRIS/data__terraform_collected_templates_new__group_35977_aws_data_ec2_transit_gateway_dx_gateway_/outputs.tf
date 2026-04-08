output "arn" {
  description = "ARN of the attachment"
  value       = data.aws_ec2_transit_gateway_dx_gateway_attachment.this.arn
}

output "id" {
  description = "EC2 Transit Gateway Attachment identifier"
  value       = data.aws_ec2_transit_gateway_dx_gateway_attachment.this.id
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_ec2_transit_gateway_dx_gateway_attachment.this.region
}

output "transit_gateway_id" {
  description = "Identifier of the EC2 Transit Gateway"
  value       = data.aws_ec2_transit_gateway_dx_gateway_attachment.this.transit_gateway_id
}

output "dx_gateway_id" {
  description = "Identifier of the Direct Connect Gateway"
  value       = data.aws_ec2_transit_gateway_dx_gateway_attachment.this.dx_gateway_id
}

output "tags" {
  description = "Key-value tags for the EC2 Transit Gateway Attachment"
  value       = data.aws_ec2_transit_gateway_dx_gateway_attachment.this.tags
}