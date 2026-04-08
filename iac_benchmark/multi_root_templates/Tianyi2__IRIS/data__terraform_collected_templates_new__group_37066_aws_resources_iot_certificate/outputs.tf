output "id" {
  description = "The internal ID assigned to this certificate"
  value       = aws_iot_certificate.this.id
}

output "arn" {
  description = "The ARN of the created certificate"
  value       = aws_iot_certificate.this.arn
}

output "ca_certificate_id" {
  description = "The certificate ID of the CA certificate used to sign the certificate"
  value       = aws_iot_certificate.this.ca_certificate_id
}

output "certificate_pem" {
  description = "The certificate data, in PEM format"
  value       = aws_iot_certificate.this.certificate_pem
  sensitive   = true
}

output "public_key" {
  description = "When neither CSR nor certificate is provided, the public key"
  value       = aws_iot_certificate.this.public_key
  sensitive   = true
}

output "private_key" {
  description = "When neither CSR nor certificate is provided, the private key"
  value       = aws_iot_certificate.this.private_key
  sensitive   = true
}