output "attributes" {
  description = "The attributes of a third-party custom source."
  value = {
    crawler_arn  = aws_securitylake_custom_log_source.this.attributes[0].crawler_arn
    database_arn = aws_securitylake_custom_log_source.this.attributes[0].database_arn
    table_arn    = aws_securitylake_custom_log_source.this.attributes[0].table_arn
  }
}

output "provider_details" {
  description = "The details of the log provider for a third-party custom source."
  value = {
    location = aws_securitylake_custom_log_source.this.provider_details[0].location
    role_arn = aws_securitylake_custom_log_source.this.provider_details[0].role_arn
  }
}

output "crawler_arn" {
  description = "The ARN of the AWS Glue crawler."
  value       = aws_securitylake_custom_log_source.this.attributes[0].crawler_arn
}

output "database_arn" {
  description = "The ARN of the AWS Glue database where results are written."
  value       = aws_securitylake_custom_log_source.this.attributes[0].database_arn
}

output "table_arn" {
  description = "The ARN of the AWS Glue table."
  value       = aws_securitylake_custom_log_source.this.attributes[0].table_arn
}

output "provider_details_location" {
  description = "The location of the partition in the Amazon S3 bucket for Security Lake."
  value       = aws_securitylake_custom_log_source.this.provider_details[0].location
}

output "provider_details_role_arn" {
  description = "The ARN of the IAM role to be used by the entity putting logs into your custom source partition."
  value       = aws_securitylake_custom_log_source.this.provider_details[0].role_arn
}