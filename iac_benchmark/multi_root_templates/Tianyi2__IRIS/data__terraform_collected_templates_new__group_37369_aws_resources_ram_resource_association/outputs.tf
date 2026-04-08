output "id" {
  description = "The Amazon Resource Name (ARN) of the resource share."
  value       = aws_ram_resource_association.this.id
}