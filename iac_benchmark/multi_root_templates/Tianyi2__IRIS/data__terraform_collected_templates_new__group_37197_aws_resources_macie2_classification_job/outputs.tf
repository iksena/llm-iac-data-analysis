output "id" {
  description = "The unique identifier (ID) of the macie classification job"
  value       = aws_macie2_classification_job.this.id
}

output "created_at" {
  description = "The date and time, in UTC and extended RFC 3339 format, when the job was created"
  value       = aws_macie2_classification_job.this.created_at
}

output "user_paused_details" {
  description = "If the current status of the job is USER_PAUSED, specifies when the job was paused and when the job or job run will expire and be canceled if it isn't resumed"
  value       = aws_macie2_classification_job.this.user_paused_details
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_macie2_classification_job.this.tags_all
}