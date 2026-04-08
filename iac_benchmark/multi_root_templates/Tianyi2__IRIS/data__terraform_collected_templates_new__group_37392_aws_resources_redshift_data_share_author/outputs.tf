output "id" {
  description = "A comma-delimited string concatenating data_share_arn and consumer_identifier."
  value       = aws_redshift_data_share_authorization.this.id
}

output "managed_by" {
  description = "Identifier of a datashare to show its managing entity."
  value       = aws_redshift_data_share_authorization.this.managed_by
}

output "producer_arn" {
  description = "Amazon Resource Name (ARN) of the producer."
  value       = aws_redshift_data_share_authorization.this.producer_arn
}