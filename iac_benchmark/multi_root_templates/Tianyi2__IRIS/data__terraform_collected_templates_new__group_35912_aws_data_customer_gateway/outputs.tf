output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_customer_gateway.this.region
}

output "id" {
  description = "ID of the gateway."
  value       = data.aws_customer_gateway.this.id
}

output "filter" {
  description = "One or more name-value pairs to filter by."
  value       = var.filter
}

output "arn" {
  description = "ARN of the customer gateway."
  value       = data.aws_customer_gateway.this.arn
}

output "bgp_asn" {
  description = "Gateway's Border Gateway Protocol (BGP) Autonomous System Number (ASN)."
  value       = data.aws_customer_gateway.this.bgp_asn
}

output "bgp_asn_extended" {
  description = "Gateway's Border Gateway Protocol (BGP) Autonomous System Number (ASN)."
  value       = data.aws_customer_gateway.this.bgp_asn_extended
}

output "certificate_arn" {
  description = "ARN for the customer gateway certificate."
  value       = data.aws_customer_gateway.this.certificate_arn
}

output "device_name" {
  description = "Name for the customer gateway device."
  value       = data.aws_customer_gateway.this.device_name
}

output "ip_address" {
  description = "IP address of the gateway's Internet-routable external interface."
  value       = data.aws_customer_gateway.this.ip_address
}

output "tags" {
  description = "Map of key-value pairs assigned to the gateway."
  value       = data.aws_customer_gateway.this.tags
}

output "type" {
  description = "Type of customer gateway. The only type AWS supports at this time is \"ipsec.1\"."
  value       = data.aws_customer_gateway.this.type
}