output "established" {
  description = "The last established policy for the Multi-Region Access Point."
  value       = aws_s3control_multi_region_access_point_policy.this.established
}

output "id" {
  description = "The AWS account ID and access point name separated by a colon (:)."
  value       = aws_s3control_multi_region_access_point_policy.this.id
}

output "proposed" {
  description = "The proposed policy for the Multi-Region Access Point."
  value       = aws_s3control_multi_region_access_point_policy.this.proposed
}