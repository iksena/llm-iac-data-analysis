output "id" {
  description = "AWS Region."
  value       = data.aws_ec2_local_gateways.this.id
}

output "ids" {
  description = "Set of all the Local Gateway identifiers."
  value       = data.aws_ec2_local_gateways.this.ids
}