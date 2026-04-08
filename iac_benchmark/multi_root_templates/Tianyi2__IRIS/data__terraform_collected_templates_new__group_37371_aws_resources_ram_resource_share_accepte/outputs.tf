output "invitation_arn" {
  description = "The ARN of the resource share invitation."
  value       = aws_ram_resource_share_accepter.this.invitation_arn
}

output "share_id" {
  description = "The ID of the resource share as displayed in the console."
  value       = aws_ram_resource_share_accepter.this.share_id
}

output "status" {
  description = "The status of the resource share (ACTIVE, PENDING, FAILED, DELETING, DELETED)."
  value       = aws_ram_resource_share_accepter.this.status
}

output "receiver_account_id" {
  description = "The account ID of the receiver account which accepts the invitation."
  value       = aws_ram_resource_share_accepter.this.receiver_account_id
}

output "sender_account_id" {
  description = "The account ID of the sender account which submits the invitation."
  value       = aws_ram_resource_share_accepter.this.sender_account_id
}

output "share_name" {
  description = "The name of the resource share."
  value       = aws_ram_resource_share_accepter.this.share_name
}

output "resources" {
  description = "A list of the resource ARNs shared via the resource share."
  value       = aws_ram_resource_share_accepter.this.resources
}