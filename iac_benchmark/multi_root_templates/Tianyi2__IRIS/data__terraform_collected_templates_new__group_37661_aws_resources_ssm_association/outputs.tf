output "arn" {
  description = "The ARN of the SSM association"
  value       = aws_ssm_association.this.arn
}

output "association_id" {
  description = "The ID of the SSM association."
  value       = aws_ssm_association.this.association_id
}

output "name" {
  description = "The name of the SSM document to apply."
  value       = aws_ssm_association.this.name
}

output "parameters" {
  description = "Additional parameters passed to the SSM document."
  value       = aws_ssm_association.this.parameters
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ssm_association.this.tags_all
}