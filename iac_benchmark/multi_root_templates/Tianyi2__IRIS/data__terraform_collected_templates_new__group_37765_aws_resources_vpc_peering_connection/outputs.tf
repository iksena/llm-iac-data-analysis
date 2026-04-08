output "id" {
  description = "The ID of the VPC Peering Connection."
  value       = aws_vpc_peering_connection.this.id
}

output "accept_status" {
  description = "The status of the VPC Peering Connection request."
  value       = aws_vpc_peering_connection.this.accept_status
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_vpc_peering_connection.this.tags_all
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_vpc_peering_connection.this.region
}

output "peer_owner_id" {
  description = "The AWS account ID of the target peer VPC."
  value       = aws_vpc_peering_connection.this.peer_owner_id
}

output "peer_vpc_id" {
  description = "The ID of the target VPC with which the VPC Peering Connection is created."
  value       = aws_vpc_peering_connection.this.peer_vpc_id
}

output "vpc_id" {
  description = "The ID of the requester VPC."
  value       = aws_vpc_peering_connection.this.vpc_id
}

output "auto_accept" {
  description = "Accept the peering (both VPCs need to be in the same AWS account and region)."
  value       = aws_vpc_peering_connection.this.auto_accept
}

output "peer_region" {
  description = "The region of the accepter VPC of the VPC Peering Connection."
  value       = aws_vpc_peering_connection.this.peer_region
}

output "accepter" {
  description = "The accepter configuration block for VPC Peering Connection options."
  value       = var.accepter
}

output "requester" {
  description = "The requester configuration block for VPC Peering Connection options."
  value       = var.requester
}

output "tags" {
  description = "A map of tags assigned to the resource."
  value       = aws_vpc_peering_connection.this.tags
}