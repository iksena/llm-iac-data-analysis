output "id" {
  description = "The user pool ID or the user pool ID and Client Id separated by a ':' if the configuration is client specific."
  value       = aws_cognito_risk_configuration.this.id
}