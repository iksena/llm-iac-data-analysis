output "arns" {
  description = "ARNs of the matched security groups."
  value       = data.aws_security_groups.this.arns
}

output "id" {
  description = "AWS Region."
  value       = data.aws_security_groups.this.id
}

output "ids" {
  description = "IDs of the matches security groups."
  value       = data.aws_security_groups.this.ids
}

output "vpc_ids" {
  description = "VPC IDs of the matched security groups. The data source's tag or filter will span VPCs unless the vpc-id filter is also used."
  value       = data.aws_security_groups.this.vpc_ids
}