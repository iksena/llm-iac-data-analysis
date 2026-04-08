output "access_key_id" {
  description = "Access key ID."
  value       = aws_lightsail_bucket_access_key.this.access_key_id
}

output "created_at" {
  description = "Date and time when the access key was created."
  value       = aws_lightsail_bucket_access_key.this.created_at
}

output "id" {
  description = "Combination of attributes separated by a comma to create a unique id: bucket_name,access_key_id."
  value       = aws_lightsail_bucket_access_key.this.id
}

output "secret_access_key" {
  description = "Secret access key used to sign requests. This attribute is not available for imported resources."
  value       = aws_lightsail_bucket_access_key.this.secret_access_key
  sensitive   = true
}

output "status" {
  description = "Status of the access key."
  value       = aws_lightsail_bucket_access_key.this.status
}