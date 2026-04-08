output "has_public_access_policy" {
  description = "Indicates whether this access point currently has a policy that allows public access."
  value       = aws_s3control_object_lambda_access_point_policy.this.has_public_access_policy
}

output "id" {
  description = "The AWS account ID and access point name separated by a colon (:)."
  value       = aws_s3control_object_lambda_access_point_policy.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_s3control_object_lambda_access_point_policy.this.region
}

output "account_id" {
  description = "The AWS account ID for the account that owns the Object Lambda Access Point."
  value       = aws_s3control_object_lambda_access_point_policy.this.account_id
}

output "name" {
  description = "The name of the Object Lambda Access Point."
  value       = aws_s3control_object_lambda_access_point_policy.this.name
}

output "policy" {
  description = "The Object Lambda Access Point resource policy document."
  value       = aws_s3control_object_lambda_access_point_policy.this.policy
}