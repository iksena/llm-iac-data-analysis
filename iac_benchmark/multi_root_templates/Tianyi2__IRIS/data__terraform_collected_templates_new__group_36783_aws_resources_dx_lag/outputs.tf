output "arn" {
  description = "The ARN of the LAG."
  value       = aws_dx_lag.this.arn
}

output "has_logical_redundancy" {
  description = "Indicates whether the LAG supports a secondary BGP peer in the same address family (IPv4/IPv6)."
  value       = aws_dx_lag.this.has_logical_redundancy
}

output "id" {
  description = "The ID of the LAG."
  value       = aws_dx_lag.this.id
}

output "jumbo_frame_capable" {
  description = "Indicates whether jumbo frames (9001 MTU) are supported."
  value       = aws_dx_lag.this.jumbo_frame_capable
}

output "owner_account_id" {
  description = "The ID of the AWS account that owns the LAG."
  value       = aws_dx_lag.this.owner_account_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_dx_lag.this.tags_all
}