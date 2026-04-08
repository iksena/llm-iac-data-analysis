output "arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this Human Task UI."
  value       = aws_sagemaker_human_task_ui.this.arn
}

output "id" {
  description = "The name of the Human Task UI."
  value       = aws_sagemaker_human_task_ui.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_sagemaker_human_task_ui.this.tags_all
}

output "ui_template_content_sha256" {
  description = "The SHA-256 digest of the contents of the template."
  value       = aws_sagemaker_human_task_ui.this.ui_template[0].content_sha256
}

output "ui_template_url" {
  description = "The URL for the user interface template."
  value       = aws_sagemaker_human_task_ui.this.ui_template[0].url
}