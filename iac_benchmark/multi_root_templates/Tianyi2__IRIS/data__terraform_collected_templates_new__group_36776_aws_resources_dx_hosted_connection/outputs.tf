output "aws_device" {
  description = "The Direct Connect endpoint on which the physical connection terminates"
  value       = aws_dx_hosted_connection.this.aws_device
}

output "connection_region" {
  description = "The AWS Region where the connection is located"
  value       = aws_dx_hosted_connection.this.connection_region
}

output "has_logical_redundancy" {
  description = "Indicates whether the connection supports a secondary BGP peer in the same address family (IPv4/IPv6)"
  value       = aws_dx_hosted_connection.this.has_logical_redundancy
}

output "id" {
  description = "The ID of the hosted connection"
  value       = aws_dx_hosted_connection.this.id
}

output "jumbo_frame_capable" {
  description = "Boolean value representing if jumbo frames have been enabled for this connection"
  value       = aws_dx_hosted_connection.this.jumbo_frame_capable
}

output "lag_id" {
  description = "The ID of the LAG"
  value       = aws_dx_hosted_connection.this.lag_id
}

output "loa_issue_time" {
  description = "The time of the most recent call to DescribeLoa for this connection"
  value       = aws_dx_hosted_connection.this.loa_issue_time
}

output "location" {
  description = "The location of the connection"
  value       = aws_dx_hosted_connection.this.location
}

output "partner_name" {
  description = "The name of the AWS Direct Connect service provider associated with the connection"
  value       = aws_dx_hosted_connection.this.partner_name
}

output "provider_name" {
  description = "The name of the service provider associated with the connection"
  value       = aws_dx_hosted_connection.this.provider_name
}

output "region" {
  description = "The AWS Region where the connection is located (deprecated, use connection_region instead)"
  value       = aws_dx_hosted_connection.this.region
}

output "state" {
  description = "The state of the connection"
  value       = aws_dx_hosted_connection.this.state
}