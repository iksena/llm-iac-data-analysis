output "id" {
  description = "The ID of the virtual interface"
  value       = aws_dx_hosted_private_virtual_interface.this.id
}

output "arn" {
  description = "The ARN of the virtual interface"
  value       = aws_dx_hosted_private_virtual_interface.this.arn
}

output "jumbo_frame_capable" {
  description = "Indicates whether jumbo frames (9001 MTU) are supported"
  value       = aws_dx_hosted_private_virtual_interface.this.jumbo_frame_capable
}

output "aws_device" {
  description = "The Direct Connect endpoint on which the virtual interface terminates"
  value       = aws_dx_hosted_private_virtual_interface.this.aws_device
}