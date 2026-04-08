output "arn" {
  description = "The ARN of the connection."
  value       = aws_dx_connection.this.arn
}

output "aws_device" {
  description = "The Direct Connect endpoint on which the physical connection terminates."
  value       = aws_dx_connection.this.aws_device
}

output "has_logical_redundancy" {
  description = "Indicates whether the connection supports a secondary BGP peer in the same address family (IPv4/IPv6)."
  value       = aws_dx_connection.this.has_logical_redundancy
}

output "id" {
  description = "The ID of the connection."
  value       = aws_dx_connection.this.id
}

output "jumbo_frame_capable" {
  description = "Boolean value representing if jumbo frames have been enabled for this connection."
  value       = aws_dx_connection.this.jumbo_frame_capable
}

output "macsec_capable" {
  description = "Boolean value indicating whether the connection supports MAC Security (MACsec)."
  value       = aws_dx_connection.this.macsec_capable
}

output "owner_account_id" {
  description = "The ID of the AWS account that owns the connection."
  value       = aws_dx_connection.this.owner_account_id
}

output "partner_name" {
  description = "The name of the AWS Direct Connect service provider associated with the connection."
  value       = aws_dx_connection.this.partner_name
}

output "port_encryption_status" {
  description = "The MAC Security (MACsec) port link status of the connection."
  value       = aws_dx_connection.this.port_encryption_status
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_dx_connection.this.tags_all
}

output "vlan_id" {
  description = "The VLAN ID."
  value       = aws_dx_connection.this.vlan_id
}