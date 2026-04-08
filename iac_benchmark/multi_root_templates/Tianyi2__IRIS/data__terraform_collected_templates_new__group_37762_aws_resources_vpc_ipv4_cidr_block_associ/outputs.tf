output "id" {
  description = "The ID of the VPC CIDR association"
  value       = aws_vpc_ipv4_cidr_block_association.this.id
}