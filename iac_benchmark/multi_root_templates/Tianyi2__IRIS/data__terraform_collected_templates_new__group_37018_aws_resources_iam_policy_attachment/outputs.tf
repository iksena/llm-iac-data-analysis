output "id" {
  description = "Policy's ID."
  value       = aws_iam_policy_attachment.this.id
}

output "name" {
  description = "Name of the attachment."
  value       = aws_iam_policy_attachment.this.name
}