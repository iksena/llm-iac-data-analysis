output "arn" {
  description = "EC2 Transit Gateway Connect Peer ARN"
  value       = data.aws_ec2_transit_gateway_connect_peer.this.arn
}

output "bgp_asn" {
  description = "BGP ASN number assigned customer device"
  value       = data.aws_ec2_transit_gateway_connect_peer.this.bgp_asn
}

output "bgp_peer_address" {
  description = "The IP address assigned to customer device, which is used as BGP IP address."
  value       = data.aws_ec2_transit_gateway_connect_peer.this.bgp_peer_address
}

output "bgp_transit_gateway_addresses" {
  description = "The IP addresses assigned to Transit Gateway, which are used as BGP IP addresses."
  value       = data.aws_ec2_transit_gateway_connect_peer.this.bgp_transit_gateway_addresses
}

output "inside_cidr_blocks" {
  description = "CIDR blocks that will be used for addressing within the tunnel."
  value       = data.aws_ec2_transit_gateway_connect_peer.this.inside_cidr_blocks
}

output "peer_address" {
  description = "IP addressed assigned to customer device, which is used as tunnel endpoint"
  value       = data.aws_ec2_transit_gateway_connect_peer.this.peer_address
}

output "tags" {
  description = "Key-value tags for the EC2 Transit Gateway Connect Peer"
  value       = data.aws_ec2_transit_gateway_connect_peer.this.tags
}

output "transit_gateway_address" {
  description = "The IP address assigned to Transit Gateway, which is used as tunnel endpoint."
  value       = data.aws_ec2_transit_gateway_connect_peer.this.transit_gateway_address
}

output "transit_gateway_attachment_id" {
  description = "The Transit Gateway Connect"
  value       = data.aws_ec2_transit_gateway_connect_peer.this.transit_gateway_attachment_id
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_ec2_transit_gateway_connect_peer.this.region
}

output "filter" {
  description = "Configuration blocks containing name-values filters used"
  value       = var.filter
}

output "transit_gateway_connect_peer_id" {
  description = "Identifier of the EC2 Transit Gateway Connect Peer"
  value       = data.aws_ec2_transit_gateway_connect_peer.this.transit_gateway_connect_peer_id
}