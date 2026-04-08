output "id" {
  description = "Global Network ID and Transit Gateway ARN separated by comma"
  value       = aws_networkmanager_transit_gateway_registration.this.id
}