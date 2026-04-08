output "id" {
  description = "The Spot fleet request ID"
  value       = aws_spot_fleet_request.this.id
}

output "spot_request_state" {
  description = "The state of the Spot fleet request."
  value       = aws_spot_fleet_request.this.spot_request_state
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_spot_fleet_request.this.tags_all
}