output "arn" {
  description = "The ARN of the carrier gateway."
  value       = aws_ec2_carrier_gateway.this.arn
}

output "id" {
  description = "The ID of the carrier gateway."
  value       = aws_ec2_carrier_gateway.this.id
}

output "owner_id" {
  description = "The AWS account ID of the owner of the carrier gateway."
  value       = aws_ec2_carrier_gateway.this.owner_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ec2_carrier_gateway.this.tags_all
}