output "id" {
  description = "EC2 Transit Gateway Connect Peer identifier"
  value       = aws_ec2_transit_gateway_connect_peer.this.id
}

output "arn" {
  description = "EC2 Transit Gateway Connect Peer ARN"
  value       = aws_ec2_transit_gateway_connect_peer.this.arn
}

output "bgp_peer_address" {
  description = "The IP address assigned to customer device, which is used as BGP IP address"
  value       = aws_ec2_transit_gateway_connect_peer.this.bgp_peer_address
}

output "bgp_transit_gateway_addresses" {
  description = "The IP addresses assigned to Transit Gateway, which are used as BGP IP addresses"
  value       = aws_ec2_transit_gateway_connect_peer.this.bgp_transit_gateway_addresses
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_ec2_transit_gateway_connect_peer.this.tags_all
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_ec2_transit_gateway_connect_peer.this.region
}

output "bgp_asn" {
  description = "The BGP ASN number assigned customer device"
  value       = aws_ec2_transit_gateway_connect_peer.this.bgp_asn
}

output "inside_cidr_blocks" {
  description = "The CIDR block that will be used for addressing within the tunnel"
  value       = aws_ec2_transit_gateway_connect_peer.this.inside_cidr_blocks
}

output "peer_address" {
  description = "The IP addressed assigned to customer device, which will be used as tunnel endpoint"
  value       = aws_ec2_transit_gateway_connect_peer.this.peer_address
}

output "tags" {
  description = "Key-value tags for the EC2 Transit Gateway Connect Peer"
  value       = aws_ec2_transit_gateway_connect_peer.this.tags
}

output "transit_gateway_address" {
  description = "The IP address assigned to Transit Gateway, which will be used as tunnel endpoint"
  value       = aws_ec2_transit_gateway_connect_peer.this.transit_gateway_address
}

output "transit_gateway_attachment_id" {
  description = "The Transit Gateway Connect attachment ID"
  value       = aws_ec2_transit_gateway_connect_peer.this.transit_gateway_attachment_id
}