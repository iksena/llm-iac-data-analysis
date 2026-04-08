output "arn" {
  description = "ARN of the attachment."
  value       = aws_ec2_transit_gateway_vpc_attachment.this.arn
}

output "id" {
  description = "EC2 Transit Gateway Attachment identifier."
  value       = aws_ec2_transit_gateway_vpc_attachment.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ec2_transit_gateway_vpc_attachment.this.tags_all
}

output "vpc_owner_id" {
  description = "Identifier of the AWS account that owns the EC2 VPC."
  value       = aws_ec2_transit_gateway_vpc_attachment.this.vpc_owner_id
}