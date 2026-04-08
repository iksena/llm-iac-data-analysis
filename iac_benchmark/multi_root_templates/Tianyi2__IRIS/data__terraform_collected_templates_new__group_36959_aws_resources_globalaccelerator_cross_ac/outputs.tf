output "arn" {
  description = "ARN of the Cross Account Attachment."
  value       = aws_globalaccelerator_cross_account_attachment.this.arn
}

output "id" {
  description = "ID of the Cross Account Attachment."
  value       = aws_globalaccelerator_cross_account_attachment.this.id
}

output "created_time" {
  description = "Creation Time when the Cross Account Attachment."
  value       = aws_globalaccelerator_cross_account_attachment.this.created_time
}

output "last_modified_time" {
  description = "Last modified time of the Cross Account Attachment."
  value       = aws_globalaccelerator_cross_account_attachment.this.last_modified_time
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_globalaccelerator_cross_account_attachment.this.tags_all
}