output "arn" {
  description = "EC2 Transit Gateway Policy Table Amazon Resource Name (ARN)."
  value       = aws_ec2_transit_gateway_policy_table.this.arn
}

output "id" {
  description = "EC2 Transit Gateway Policy Table identifier."
  value       = aws_ec2_transit_gateway_policy_table.this.id
}

output "state" {
  description = "The state of the EC2 Transit Gateway Policy Table."
  value       = aws_ec2_transit_gateway_policy_table.this.state
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ec2_transit_gateway_policy_table.this.tags_all
}