output "id" {
  description = "The ID of the virtual interface."
  value       = aws_dx_hosted_public_virtual_interface.this.id
}

output "arn" {
  description = "The ARN of the virtual interface."
  value       = aws_dx_hosted_public_virtual_interface.this.arn
}

output "aws_device" {
  description = "The Direct Connect endpoint on which the virtual interface terminates."
  value       = aws_dx_hosted_public_virtual_interface.this.aws_device
}