output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_ec2_local_gateway.this.region
}

output "id" {
  description = "Id of the Local Gateway"
  value       = data.aws_ec2_local_gateway.this.id
}

output "state" {
  description = "State of the local gateway"
  value       = data.aws_ec2_local_gateway.this.state
}

output "tags" {
  description = "Mapping of tags for the Local Gateway"
  value       = data.aws_ec2_local_gateway.this.tags
}

output "outpost_arn" {
  description = "ARN of Outpost"
  value       = data.aws_ec2_local_gateway.this.outpost_arn
}

output "owner_id" {
  description = "AWS account identifier that owns the Local Gateway"
  value       = data.aws_ec2_local_gateway.this.owner_id
}