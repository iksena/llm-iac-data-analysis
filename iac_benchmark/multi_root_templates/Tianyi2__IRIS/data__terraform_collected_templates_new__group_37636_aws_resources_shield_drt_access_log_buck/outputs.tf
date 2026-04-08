output "id" {
  description = "The ID of the Shield DRT access log bucket association (same as log_bucket)."
  value       = aws_shield_drt_access_log_bucket_association.this.id
}

output "log_bucket" {
  description = "The Amazon S3 bucket that contains the logs shared with Shield DRT."
  value       = aws_shield_drt_access_log_bucket_association.this.log_bucket
}

output "role_arn_association_id" {
  description = "The ID of the Role Arn association used for allowing Shield DRT Access."
  value       = aws_shield_drt_access_log_bucket_association.this.role_arn_association_id
}