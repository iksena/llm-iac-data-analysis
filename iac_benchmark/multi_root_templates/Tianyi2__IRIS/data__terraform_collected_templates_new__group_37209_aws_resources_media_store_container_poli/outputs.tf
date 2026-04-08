output "region" {
  description = "The region where the MediaStore Container Policy is managed"
  value       = aws_media_store_container_policy.this.region
}

output "container_name" {
  description = "The name of the container"
  value       = aws_media_store_container_policy.this.container_name
}

output "policy" {
  description = "The contents of the policy"
  value       = aws_media_store_container_policy.this.policy
}

output "id" {
  description = "The ID of the MediaStore Container Policy"
  value       = aws_media_store_container_policy.this.id
}