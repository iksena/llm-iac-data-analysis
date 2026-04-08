output "id" {
  description = "AWS Region."
  value       = data.aws_nat_gateways.this.id
}

output "ids" {
  description = "List of all the NAT gateway ids found."
  value       = data.aws_nat_gateways.this.ids
}