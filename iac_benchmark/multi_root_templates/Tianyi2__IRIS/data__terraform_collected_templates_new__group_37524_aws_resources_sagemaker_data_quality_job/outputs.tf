output "arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this data quality job definition."
  value       = aws_sagemaker_data_quality_job_definition.this.arn
}

output "name" {
  description = "The name of the data quality job definition."
  value       = aws_sagemaker_data_quality_job_definition.this.name
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_sagemaker_data_quality_job_definition.this.tags_all
}