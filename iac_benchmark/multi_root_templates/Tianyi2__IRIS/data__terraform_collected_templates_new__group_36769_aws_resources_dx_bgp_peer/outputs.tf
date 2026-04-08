output "id" {
  description = "The ID of the BGP peer resource."
  value       = aws_dx_bgp_peer.this.id
}

output "bgp_status" {
  description = "The Up/Down state of the BGP peer."
  value       = aws_dx_bgp_peer.this.bgp_status
}

output "bgp_peer_id" {
  description = "The ID of the BGP peer."
  value       = aws_dx_bgp_peer.this.bgp_peer_id
}

output "aws_device" {
  description = "The Direct Connect endpoint on which the BGP peer terminates."
  value       = aws_dx_bgp_peer.this.aws_device
}