output "id" {
  description = "Combination of attributes separated by a comma to create a unique id: bucket_name,resource_name"
  value       = aws_lightsail_bucket_resource_access.this.id
}

output "bucket_name" {
  description = "Name of the bucket to grant access to"
  value       = aws_lightsail_bucket_resource_access.this.bucket_name
}

output "resource_name" {
  description = "Name of the resource to grant bucket access"
  value       = aws_lightsail_bucket_resource_access.this.resource_name
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_lightsail_bucket_resource_access.this.region
}