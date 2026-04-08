output "id" {
  description = "The ID of the virtual interface."
  value       = aws_dx_hosted_private_virtual_interface_accepter.this.id
}

output "arn" {
  description = "The ARN of the virtual interface."
  value       = aws_dx_hosted_private_virtual_interface_accepter.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_dx_hosted_private_virtual_interface_accepter.this.tags_all
}