output "id" {
  description = "EC2 Transit Gateway Multicast Domain Association identifier."
  value       = aws_ec2_transit_gateway_multicast_domain_association.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_ec2_transit_gateway_multicast_domain_association.this.region
}

output "subnet_id" {
  description = "The ID of the subnet associated with the transit gateway multicast domain."
  value       = aws_ec2_transit_gateway_multicast_domain_association.this.subnet_id
}

output "transit_gateway_attachment_id" {
  description = "The ID of the transit gateway attachment."
  value       = aws_ec2_transit_gateway_multicast_domain_association.this.transit_gateway_attachment_id
}

output "transit_gateway_multicast_domain_id" {
  description = "The ID of the transit gateway multicast domain."
  value       = aws_ec2_transit_gateway_multicast_domain_association.this.transit_gateway_multicast_domain_id
}