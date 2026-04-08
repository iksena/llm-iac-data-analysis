output "id" {
  description = "The Amazon Resource Name (ARN) of the associated firewall."
  value       = aws_networkfirewall_logging_configuration.this.id
}