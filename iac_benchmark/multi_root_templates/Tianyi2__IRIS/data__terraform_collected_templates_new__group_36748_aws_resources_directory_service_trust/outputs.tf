output "id" {
  description = "The Trust identifier."
  value       = aws_directory_service_trust.this.id
}

output "created_date_time" {
  description = "Date and time when the Trust was created."
  value       = aws_directory_service_trust.this.created_date_time
}

output "last_updated_date_time" {
  description = "Date and time when the Trust was last updated."
  value       = aws_directory_service_trust.this.last_updated_date_time
}

output "state_last_updated_date_time" {
  description = "Date and time when the Trust state in trust_state was last updated."
  value       = aws_directory_service_trust.this.state_last_updated_date_time
}

output "trust_state" {
  description = "State of the Trust relationship. One of Created, VerifyFailed, Verified, UpdateFailed, Updated, Deleted, or Failed."
  value       = aws_directory_service_trust.this.trust_state
}

output "trust_state_reason" {
  description = "Reason for the Trust state set in trust_state."
  value       = aws_directory_service_trust.this.trust_state_reason
}