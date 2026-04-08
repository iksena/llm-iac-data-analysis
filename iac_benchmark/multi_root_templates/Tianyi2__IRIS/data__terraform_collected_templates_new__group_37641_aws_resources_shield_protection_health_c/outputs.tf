output "id" {
  description = "The unique identifier (ID) for the Protection object that is created."
  value       = aws_shield_protection_health_check_association.this.id
}