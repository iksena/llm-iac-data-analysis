output "instance_id" {
  description = "Instance ID."
  value       = aws_network_interface_attachment.this.instance_id
}

output "network_interface_id" {
  description = "Network interface ID."
  value       = aws_network_interface_attachment.this.network_interface_id
}

output "attachment_id" {
  description = "The ENI Attachment ID."
  value       = aws_network_interface_attachment.this.attachment_id
}

output "status" {
  description = "The status of the Network Interface Attachment."
  value       = aws_network_interface_attachment.this.status
}