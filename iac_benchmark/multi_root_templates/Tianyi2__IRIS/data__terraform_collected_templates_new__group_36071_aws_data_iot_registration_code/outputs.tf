output "registration_code" {
  value       = data.aws_iot_registration_code.this.registration_code
  description = "The CA certificate registration code."
}