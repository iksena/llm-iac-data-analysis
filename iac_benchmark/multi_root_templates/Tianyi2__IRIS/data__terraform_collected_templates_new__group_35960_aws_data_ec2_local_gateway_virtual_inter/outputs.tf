output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_ec2_local_gateway_virtual_interface.this.region
}

output "id" {
  description = "Identifier of EC2 Local Gateway Virtual Interface"
  value       = data.aws_ec2_local_gateway_virtual_interface.this.id
}

output "tags" {
  description = "Key-value map of resource tags"
  value       = data.aws_ec2_local_gateway_virtual_interface.this.tags
}

output "local_address" {
  description = "Local address"
  value       = data.aws_ec2_local_gateway_virtual_interface.this.local_address
}

output "local_bgp_asn" {
  description = "Border Gateway Protocol (BGP) Autonomous System Number (ASN) of the EC2 Local Gateway"
  value       = data.aws_ec2_local_gateway_virtual_interface.this.local_bgp_asn
}

output "local_gateway_id" {
  description = "Identifier of the EC2 Local Gateway"
  value       = data.aws_ec2_local_gateway_virtual_interface.this.local_gateway_id
}

output "peer_address" {
  description = "Peer address"
  value       = data.aws_ec2_local_gateway_virtual_interface.this.peer_address
}

output "peer_bgp_asn" {
  description = "Border Gateway Protocol (BGP) Autonomous System Number (ASN) of the peer"
  value       = data.aws_ec2_local_gateway_virtual_interface.this.peer_bgp_asn
}

output "vlan" {
  description = "Virtual Local Area Network"
  value       = data.aws_ec2_local_gateway_virtual_interface.this.vlan
}