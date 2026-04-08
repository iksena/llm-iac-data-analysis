output "arn" {
  description = "ARN of the service setting."
  value       = aws_ssm_service_setting.this.arn
}

output "status" {
  description = "Status of the service setting. Value can be Default, Customized or PendingUpdate."
  value       = aws_ssm_service_setting.this.status
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_ssm_service_setting.this.region
}

output "setting_id" {
  description = "ID of the service setting."
  value       = aws_ssm_service_setting.this.setting_id
}

output "setting_value" {
  description = "Value of the service setting."
  value       = aws_ssm_service_setting.this.setting_value
}