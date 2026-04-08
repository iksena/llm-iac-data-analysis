output "id" {
  description = "A comma-delimited string concatenating data_share_arn and associate_entire_account, consumer_arn, and consumer_region. As only one of the final three arguments can be specified, the other two will always be empty."
  value       = aws_redshift_data_share_consumer_association.this.id
}

output "managed_by" {
  description = "Identifier of a datashare to show its managing entity."
  value       = aws_redshift_data_share_consumer_association.this.managed_by
}

output "producer_arn" {
  description = "Amazon Resource Name (ARN) of the producer."
  value       = aws_redshift_data_share_consumer_association.this.producer_arn
}

output "data_share_arn" {
  description = "Amazon Resource Name (ARN) of the datashare that the consumer is to use with the account or the namespace."
  value       = aws_redshift_data_share_consumer_association.this.data_share_arn
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_redshift_data_share_consumer_association.this.region
}

output "allow_writes" {
  description = "Whether to allow write operations for a datashare."
  value       = aws_redshift_data_share_consumer_association.this.allow_writes
}

output "associate_entire_account" {
  description = "Whether the datashare is associated with the entire account."
  value       = aws_redshift_data_share_consumer_association.this.associate_entire_account
}

output "consumer_arn" {
  description = "Amazon Resource Name (ARN) of the consumer that is associated with the datashare."
  value       = aws_redshift_data_share_consumer_association.this.consumer_arn
}

output "consumer_region" {
  description = "From a datashare consumer account, associates a datashare with all existing and future namespaces in the specified AWS Region."
  value       = aws_redshift_data_share_consumer_association.this.consumer_region
}