output "arn" {
  description = "The ARN of the connector"
  value       = aws_transfer_connector.this.arn
}

output "connector_id" {
  description = "The unique identifier for the AS2 profile or SFTP Profile"
  value       = aws_transfer_connector.this.connector_id
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_transfer_connector.this.region
}

output "access_role" {
  description = "The IAM Role which provides read and write access to the parent directory of the file location mentioned in the StartFileTransfer request"
  value       = aws_transfer_connector.this.access_role
}

output "url" {
  description = "The URL of the partners AS2 endpoint or SFTP endpoint"
  value       = aws_transfer_connector.this.url
}

output "logging_role" {
  description = "The IAM Role which is required for allowing the connector to turn on CloudWatch logging for Amazon S3 events"
  value       = aws_transfer_connector.this.logging_role
}

output "security_policy_name" {
  description = "Name of the security policy for the connector"
  value       = aws_transfer_connector.this.security_policy_name
}

output "as2_config" {
  description = "The AS2 configuration for the connector"
  value       = aws_transfer_connector.this.as2_config
}

output "sftp_config" {
  description = "The SFTP configuration for the connector"
  value       = aws_transfer_connector.this.sftp_config
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = aws_transfer_connector.this.tags
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_transfer_connector.this.tags_all
}