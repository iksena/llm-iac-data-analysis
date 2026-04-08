output "access_grants_instance_arn" {
  description = "Amazon Resource Name (ARN) of the S3 Access Grants instance."
  value       = aws_s3control_access_grants_instance.this.access_grants_instance_arn
}

output "access_grants_instance_id" {
  description = "Unique ID of the S3 Access Grants instance."
  value       = aws_s3control_access_grants_instance.this.access_grants_instance_id
}

output "identity_center_application_arn" {
  description = "The ARN of the AWS IAM Identity Center instance application; a subresource of the original Identity Center instance."
  value       = aws_s3control_access_grants_instance.this.identity_center_application_arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_s3control_access_grants_instance.this.tags_all
}