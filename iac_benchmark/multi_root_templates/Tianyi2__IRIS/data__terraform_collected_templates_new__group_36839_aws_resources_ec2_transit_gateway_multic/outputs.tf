output "id" {
  description = "EC2 Transit Gateway Multicast Group Member identifier."
  value       = aws_ec2_transit_gateway_multicast_group_member.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_ec2_transit_gateway_multicast_group_member.this.region
}

output "group_ip_address" {
  description = "The IP address assigned to the transit gateway multicast group."
  value       = aws_ec2_transit_gateway_multicast_group_member.this.group_ip_address
}

output "network_interface_id" {
  description = "The group members' network interface ID registered with the transit gateway multicast group."
  value       = aws_ec2_transit_gateway_multicast_group_member.this.network_interface_id
}

output "transit_gateway_multicast_domain_id" {
  description = "The ID of the transit gateway multicast domain."
  value       = aws_ec2_transit_gateway_multicast_group_member.this.transit_gateway_multicast_domain_id
}