output "name" {
  description = "The name of the Feature Group."
  value       = aws_sagemaker_feature_group.this.feature_group_name
}

output "arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this feature_group."
  value       = aws_sagemaker_feature_group.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_sagemaker_feature_group.this.tags_all
}