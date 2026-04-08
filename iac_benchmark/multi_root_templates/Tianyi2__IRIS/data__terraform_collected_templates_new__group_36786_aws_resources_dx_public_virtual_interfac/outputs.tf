output "id" {
  description = "The ID of the virtual interface"
  value       = aws_dx_public_virtual_interface.this.id
}

output "arn" {
  description = "The ARN of the virtual interface"
  value       = aws_dx_public_virtual_interface.this.arn
}

output "aws_device" {
  description = "The Direct Connect endpoint on which the virtual interface terminates"
  value       = aws_dx_public_virtual_interface.this.aws_device
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_dx_public_virtual_interface.this.tags_all
}