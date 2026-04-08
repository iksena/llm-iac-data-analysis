output "id" {
  description = "ID that represents the association of the Elastic IP address with an instance"
  value       = aws_eip_association.this.id
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_eip_association.this.region
}

output "allocation_id" {
  description = "ID of the associated Elastic IP"
  value       = aws_eip_association.this.allocation_id
}

output "allow_reassociation" {
  description = "Whether to allow an Elastic IP address to be re-associated"
  value       = aws_eip_association.this.allow_reassociation
}

output "instance_id" {
  description = "ID of the instance"
  value       = aws_eip_association.this.instance_id
}

output "network_interface_id" {
  description = "ID of the network interface"
  value       = aws_eip_association.this.network_interface_id
}

output "private_ip_address" {
  description = "Primary or secondary private IP address associated with the Elastic IP address"
  value       = aws_eip_association.this.private_ip_address
}

output "public_ip" {
  description = "Address of the associated Elastic IP"
  value       = aws_eip_association.this.public_ip
}