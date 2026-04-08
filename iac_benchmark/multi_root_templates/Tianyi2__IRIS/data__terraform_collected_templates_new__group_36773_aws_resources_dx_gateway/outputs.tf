output "arn" {
  description = "The ARN of the gateway"
  value       = aws_dx_gateway.this.arn
}

output "id" {
  description = "The ID of the gateway"
  value       = aws_dx_gateway.this.id
}

output "owner_account_id" {
  description = "AWS Account ID of the gateway"
  value       = aws_dx_gateway.this.owner_account_id
}

output "name" {
  description = "The name of the connection"
  value       = aws_dx_gateway.this.name
}

output "amazon_side_asn" {
  description = "The ASN configured on the Amazon side of the connection"
  value       = aws_dx_gateway.this.amazon_side_asn
}