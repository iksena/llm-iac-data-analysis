output "arn" {
  description = "Amazon Resource Name (ARN) for the user"
  value       = aws_quicksight_user.this.arn
}

output "id" {
  description = "Unique identifier consisting of the account ID, the namespace, and the user name separated by /s"
  value       = aws_quicksight_user.this.id
}

output "user_invitation_url" {
  description = "URL the user visits to complete registration and provide a password. Returned only for users with an identity type of QUICKSIGHT"
  value       = aws_quicksight_user.this.user_invitation_url
}