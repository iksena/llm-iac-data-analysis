output "association_id" {
  description = "ID representing the association of the address with an instance in a VPC."
  value       = data.aws_eip.this.association_id
}

output "carrier_ip" {
  description = "Carrier IP address."
  value       = data.aws_eip.this.carrier_ip
}

output "customer_owned_ip" {
  description = "Customer Owned IP."
  value       = data.aws_eip.this.customer_owned_ip
}

output "customer_owned_ipv4_pool" {
  description = "The ID of a Customer Owned IP Pool. For more on customer owned IP addressed check out Customer-owned IP addresses guide."
  value       = data.aws_eip.this.customer_owned_ipv4_pool
}

output "domain" {
  description = "Whether the address is for use in EC2-Classic (standard) or in a VPC (vpc)."
  value       = data.aws_eip.this.domain
}

output "id" {
  description = "If VPC Elastic IP, the allocation identifier. If EC2-Classic Elastic IP, the public IP address."
  value       = data.aws_eip.this.id
}

output "instance_id" {
  description = "ID of the instance that the address is associated with (if any)."
  value       = data.aws_eip.this.instance_id
}

output "ipam_pool_id" {
  description = "The ID of an IPAM pool which has an Amazon-provided or BYOIP public IPv4 CIDR provisioned to it."
  value       = data.aws_eip.this.ipam_pool_id
}

output "network_interface_id" {
  description = "The ID of the network interface."
  value       = data.aws_eip.this.network_interface_id
}

output "network_interface_owner_id" {
  description = "The ID of the AWS account that owns the network interface."
  value       = data.aws_eip.this.network_interface_owner_id
}

output "private_ip" {
  description = "Private IP address associated with the Elastic IP address."
  value       = data.aws_eip.this.private_ip
}

output "private_dns" {
  description = "Private DNS associated with the Elastic IP address."
  value       = data.aws_eip.this.private_dns
}

output "ptr_record" {
  description = "The DNS pointer (PTR) record for the IP address."
  value       = data.aws_eip.this.ptr_record
}

output "public_ip" {
  description = "Public IP address of Elastic IP."
  value       = data.aws_eip.this.public_ip
}

output "public_dns" {
  description = "Public DNS associated with the Elastic IP address."
  value       = data.aws_eip.this.public_dns
}

output "public_ipv4_pool" {
  description = "ID of an address pool."
  value       = data.aws_eip.this.public_ipv4_pool
}

output "tags" {
  description = "Key-value map of tags associated with Elastic IP."
  value       = data.aws_eip.this.tags
}