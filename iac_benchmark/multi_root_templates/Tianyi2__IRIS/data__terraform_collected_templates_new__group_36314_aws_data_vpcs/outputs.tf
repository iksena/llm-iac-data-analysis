output "id" {
  description = "AWS Region."
  value       = data.aws_vpcs.this.id
}

output "ids" {
  description = "List of all the VPC Ids found."
  value       = data.aws_vpcs.this.ids
}