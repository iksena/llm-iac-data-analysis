output "id" {
  description = "AWS Region"
  value       = data.aws_vpc_peering_connections.this.id
}

output "ids" {
  description = "IDs of the VPC Peering Connections"
  value       = data.aws_vpc_peering_connections.this.ids
}