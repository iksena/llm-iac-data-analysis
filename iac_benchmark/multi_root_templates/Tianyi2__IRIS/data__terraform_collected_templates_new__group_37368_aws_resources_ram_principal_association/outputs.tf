output "id" {
  description = "The Amazon Resource Name (ARN) of the Resource Share and the principal, separated by a comma."
  value       = aws_ram_principal_association.this.id
}