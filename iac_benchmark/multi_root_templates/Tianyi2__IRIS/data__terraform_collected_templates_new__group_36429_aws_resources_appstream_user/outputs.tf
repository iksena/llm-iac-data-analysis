output "arn" {
  description = "ARN of the appstream user"
  value       = aws_appstream_user.this.arn
}

output "created_time" {
  description = "Date and time, in UTC and extended RFC 3339 format, when the user was created"
  value       = aws_appstream_user.this.created_time
}

output "id" {
  description = "Unique ID of the appstream user"
  value       = aws_appstream_user.this.id
}

# output "status" {
#   description = "Status of the user in the user pool"
#   value       = aws_appstream_user.this.status
# }