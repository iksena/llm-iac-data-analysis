output "id" {
  description = "Unique ID of the appstream User Stack association"
  value       = aws_appstream_user_stack_association.this.id
}

output "authentication_type" {
  description = "Authentication type for the user"
  value       = aws_appstream_user_stack_association.this.authentication_type
}

output "stack_name" {
  description = "Name of the stack that is associated with the user"
  value       = aws_appstream_user_stack_association.this.stack_name
}

output "user_name" {
  description = "Email address of the user who is associated with the stack"
  value       = aws_appstream_user_stack_association.this.user_name
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_appstream_user_stack_association.this.region
}

output "send_email_notification" {
  description = "Whether a welcome email is sent to a user after the user is created in the user pool"
  value       = aws_appstream_user_stack_association.this.send_email_notification
}