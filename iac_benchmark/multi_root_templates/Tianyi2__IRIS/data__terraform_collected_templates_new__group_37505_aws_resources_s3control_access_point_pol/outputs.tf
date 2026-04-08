output "has_public_access_policy" {
  description = "Indicates whether this access point currently has a policy that allows public access."
  value       = aws_s3control_access_point_policy.this.has_public_access_policy
}

output "id" {
  description = "The AWS account ID and access point name separated by a colon (:)."
  value       = aws_s3control_access_point_policy.this.id
}

output "access_point_arn" {
  description = "The ARN of the access point that you want to associate with the specified policy."
  value       = aws_s3control_access_point_policy.this.access_point_arn
}

output "policy" {
  description = "The policy that you want to apply to the specified access point."
  value       = aws_s3control_access_point_policy.this.policy
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_s3control_access_point_policy.this.region
}