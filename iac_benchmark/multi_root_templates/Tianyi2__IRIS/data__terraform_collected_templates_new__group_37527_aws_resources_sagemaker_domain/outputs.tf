output "arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this Domain"
  value       = aws_sagemaker_domain.this.arn
}

output "home_efs_file_system_id" {
  description = "The ID of the Amazon Elastic File System (EFS) managed by this Domain"
  value       = aws_sagemaker_domain.this.home_efs_file_system_id
}

output "id" {
  description = "The ID of the Domain"
  value       = aws_sagemaker_domain.this.id
}

output "security_group_id_for_domain_boundary" {
  description = "The ID of the security group that authorizes traffic between the RSessionGateway apps and the RStudioServerPro app"
  value       = aws_sagemaker_domain.this.security_group_id_for_domain_boundary
}

output "single_sign_on_application_arn" {
  description = "The ARN of the application managed by SageMaker AI in IAM Identity Center. This value is only returned for domains created after September 19, 2023"
  value       = aws_sagemaker_domain.this.single_sign_on_application_arn
}

output "single_sign_on_managed_application_instance_id" {
  description = "The SSO managed application instance ID"
  value       = aws_sagemaker_domain.this.single_sign_on_managed_application_instance_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_sagemaker_domain.this.tags_all
}

output "url" {
  description = "The domain's URL"
  value       = aws_sagemaker_domain.this.url
}