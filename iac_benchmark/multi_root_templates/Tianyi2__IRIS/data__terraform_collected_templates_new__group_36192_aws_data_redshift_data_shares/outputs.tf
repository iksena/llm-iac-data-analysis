output "id" {
  description = "AWS region."
  value       = data.aws_redshift_data_shares.this.id
}

output "data_shares" {
  description = "An array of all data shares in the current region."
  value       = data.aws_redshift_data_shares.this.data_shares
}

output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_redshift_data_shares.this.region
}