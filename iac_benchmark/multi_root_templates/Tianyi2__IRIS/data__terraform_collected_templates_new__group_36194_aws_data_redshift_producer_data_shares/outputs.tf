output "id" {
  description = "Producer ARN"
  value       = data.aws_redshift_producer_data_shares.this.id
}

output "data_shares" {
  description = "An array of all data shares in the producer"
  value       = data.aws_redshift_producer_data_shares.this.data_shares
}

output "producer_arn" {
  description = "Amazon Resource Name (ARN) of the producer namespace"
  value       = data.aws_redshift_producer_data_shares.this.producer_arn
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_redshift_producer_data_shares.this.region
}

output "status" {
  description = "Status of a datashare in the producer"
  value       = data.aws_redshift_producer_data_shares.this.status
}