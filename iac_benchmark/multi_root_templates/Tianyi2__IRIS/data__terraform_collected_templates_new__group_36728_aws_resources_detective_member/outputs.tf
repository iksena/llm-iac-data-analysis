output "id" {
  description = "Unique identifier (ID) of the Detective"
  value       = aws_detective_member.this.id
}

output "status" {
  description = "Current membership status of the member account"
  value       = aws_detective_member.this.status
}

output "administrator_id" {
  description = "AWS account ID for the administrator account"
  value       = aws_detective_member.this.administrator_id
}

output "volume_usage_in_bytes" {
  description = "Data volume in bytes per day for the member account"
  value       = aws_detective_member.this.volume_usage_in_bytes
}

output "invited_time" {
  description = "Date and time, in UTC and extended RFC 3339 format, when an Amazon Detective membership invitation was last sent to the account"
  value       = aws_detective_member.this.invited_time
}

output "updated_time" {
  description = "Date and time, in UTC and extended RFC 3339 format, of the most recent change to the member account's status"
  value       = aws_detective_member.this.updated_time
}