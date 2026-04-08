output "allocation_id" {
  description = "ID that AWS assigns to represent the allocation of the Elastic IP address for use with instances in a VPC."
  value       = aws_eip.this.allocation_id
}

output "association_id" {
  description = "ID representing the association of the address with an instance in a VPC."
  value       = aws_eip.this.association_id
}

output "carrier_ip" {
  description = "Carrier IP address."
  value       = aws_eip.this.carrier_ip
}

output "customer_owned_ip" {
  description = "Customer owned IP."
  value       = aws_eip.this.customer_owned_ip
}

output "id" {
  description = "Contains the EIP allocation ID."
  value       = aws_eip.this.id
}

output "private_dns" {
  description = "The Private DNS associated with the Elastic IP address (if in VPC)."
  value       = aws_eip.this.private_dns
}

output "private_ip" {
  description = "Contains the private IP address (if in VPC)."
  value       = aws_eip.this.private_ip
}

output "ptr_record" {
  description = "The DNS pointer (PTR) record for the IP address."
  value       = aws_eip.this.ptr_record
}

output "public_dns" {
  description = "Public DNS associated with the Elastic IP address."
  value       = aws_eip.this.public_dns
}

output "public_ip" {
  description = "Contains the public IP address."
  value       = aws_eip.this.public_ip
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_eip.this.tags_all
}