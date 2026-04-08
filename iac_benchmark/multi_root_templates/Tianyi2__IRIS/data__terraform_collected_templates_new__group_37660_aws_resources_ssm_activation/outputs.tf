output "id" {
  description = "The activation ID."
  value       = aws_ssm_activation.this.id
}

output "activation_code" {
  description = "The code the system generates when it processes the activation."
  value       = aws_ssm_activation.this.activation_code
  sensitive   = true
}

output "name" {
  description = "The default name of the registered managed instance."
  value       = aws_ssm_activation.this.name
}

output "description" {
  description = "The description of the resource that was registered."
  value       = aws_ssm_activation.this.description
}

output "expired" {
  description = "If the current activation has expired."
  value       = aws_ssm_activation.this.expired
}

output "expiration_date" {
  description = "The date by which this activation request should expire. The default value is 24 hours."
  value       = aws_ssm_activation.this.expiration_date
}

output "iam_role" {
  description = "The IAM Role attached to the managed instance."
  value       = aws_ssm_activation.this.iam_role
}

output "registration_limit" {
  description = "The maximum number of managed instances you want to be registered. The default value is 1 instance."
  value       = aws_ssm_activation.this.registration_limit
}

output "registration_count" {
  description = "The number of managed instances that are currently registered using this activation."
  value       = aws_ssm_activation.this.registration_count
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ssm_activation.this.tags_all
}