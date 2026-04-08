output "id" {
  description = "The internal ID assigned to this CA certificate"
  value       = aws_iot_ca_certificate.this.id
}

output "arn" {
  description = "The ARN of the created CA certificate"
  value       = aws_iot_ca_certificate.this.arn
}

output "customer_version" {
  description = "The customer version of the CA certificate"
  value       = aws_iot_ca_certificate.this.customer_version
}

output "generation_id" {
  description = "The generation ID of the CA certificate"
  value       = aws_iot_ca_certificate.this.generation_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_iot_ca_certificate.this.tags_all
}

output "validity" {
  description = "When the CA certificate is valid"
  value       = aws_iot_ca_certificate.this.validity
}

output "validity_not_after" {
  description = "The certificate is not valid after this date"
  value       = aws_iot_ca_certificate.this.validity[0].not_after
}

output "validity_not_before" {
  description = "The certificate is not valid before this date"
  value       = aws_iot_ca_certificate.this.validity[0].not_before
}