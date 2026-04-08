output "arn" {
  description = "ARN of the attachment"
  value       = aws_ec2_transit_gateway_peering_attachment.this.arn
}

output "id" {
  description = "EC2 Transit Gateway Attachment identifier"
  value       = aws_ec2_transit_gateway_peering_attachment.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_ec2_transit_gateway_peering_attachment.this.tags_all
}