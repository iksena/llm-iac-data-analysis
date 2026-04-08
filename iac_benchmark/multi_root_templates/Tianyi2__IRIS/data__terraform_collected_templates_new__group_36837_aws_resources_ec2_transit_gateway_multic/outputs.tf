output "id" {
  description = "EC2 Transit Gateway Multicast Domain identifier."
  value       = aws_ec2_transit_gateway_multicast_domain.this.id
}

output "arn" {
  description = "EC2 Transit Gateway Multicast Domain Amazon Resource Name (ARN)."
  value       = aws_ec2_transit_gateway_multicast_domain.this.arn
}

output "owner_id" {
  description = "Identifier of the AWS account that owns the EC2 Transit Gateway Multicast Domain."
  value       = aws_ec2_transit_gateway_multicast_domain.this.owner_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ec2_transit_gateway_multicast_domain.this.tags_all
}