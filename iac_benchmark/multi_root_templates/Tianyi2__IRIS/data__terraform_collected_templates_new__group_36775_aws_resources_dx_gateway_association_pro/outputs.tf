output "id" {
  description = "Direct Connect Gateway Association Proposal identifier."
  value       = aws_dx_gateway_association_proposal.this.id
}

output "associated_gateway_owner_account_id" {
  description = "The ID of the AWS account that owns the VGW or transit gateway with which to associate the Direct Connect gateway."
  value       = aws_dx_gateway_association_proposal.this.associated_gateway_owner_account_id
}

output "associated_gateway_type" {
  description = "The type of the associated gateway, transitGateway or virtualPrivateGateway."
  value       = aws_dx_gateway_association_proposal.this.associated_gateway_type
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_dx_gateway_association_proposal.this.region
}

output "associated_gateway_id" {
  description = "The ID of the VGW or transit gateway with which to associate the Direct Connect gateway."
  value       = aws_dx_gateway_association_proposal.this.associated_gateway_id
}

output "dx_gateway_id" {
  description = "Direct Connect Gateway identifier."
  value       = aws_dx_gateway_association_proposal.this.dx_gateway_id
}

output "dx_gateway_owner_account_id" {
  description = "AWS Account identifier of the Direct Connect Gateway's owner."
  value       = aws_dx_gateway_association_proposal.this.dx_gateway_owner_account_id
}

output "allowed_prefixes" {
  description = "VPC prefixes (CIDRs) to advertise to the Direct Connect gateway."
  value       = aws_dx_gateway_association_proposal.this.allowed_prefixes
}