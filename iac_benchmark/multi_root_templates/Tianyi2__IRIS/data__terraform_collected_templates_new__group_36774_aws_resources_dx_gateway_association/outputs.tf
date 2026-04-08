output "associated_gateway_type" {
  description = "The type of the associated gateway, transitGateway or virtualPrivateGateway."
  value       = aws_dx_gateway_association.this.associated_gateway_type
}

output "dx_gateway_association_id" {
  description = "The ID of the Direct Connect gateway association."
  value       = aws_dx_gateway_association.this.dx_gateway_association_id
}

output "dx_gateway_owner_account_id" {
  description = "The ID of the AWS account that owns the Direct Connect gateway."
  value       = aws_dx_gateway_association.this.dx_gateway_owner_account_id
}

output "transit_gateway_attachment_id" {
  description = "The ID of the Transit Gateway Attachment when the type is transitGateway."
  value       = aws_dx_gateway_association.this.transit_gateway_attachment_id
}