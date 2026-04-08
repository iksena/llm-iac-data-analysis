output "id" {
  description = "The ID of the VPC Peering Connection."
  value       = aws_vpc_peering_connection_accepter.this.id
}

output "accept_status" {
  description = "The status of the VPC Peering Connection request."
  value       = aws_vpc_peering_connection_accepter.this.accept_status
}

output "vpc_id" {
  description = "The ID of the accepter VPC."
  value       = aws_vpc_peering_connection_accepter.this.vpc_id
}

output "peer_vpc_id" {
  description = "The ID of the requester VPC."
  value       = aws_vpc_peering_connection_accepter.this.peer_vpc_id
}

output "peer_owner_id" {
  description = "The AWS account ID of the owner of the requester VPC."
  value       = aws_vpc_peering_connection_accepter.this.peer_owner_id
}

output "peer_region" {
  description = "The region of the accepter VPC."
  value       = aws_vpc_peering_connection_accepter.this.peer_region
}

output "accepter" {
  description = "A configuration block that describes VPC Peering Connection options set for the accepter VPC."
  value       = aws_vpc_peering_connection_accepter.this.accepter
}

output "requester" {
  description = "A configuration block that describes VPC Peering Connection options set for the requester VPC."
  value       = aws_vpc_peering_connection_accepter.this.requester
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_vpc_peering_connection_accepter.this.tags_all
}