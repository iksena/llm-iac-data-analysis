output "aws_account_id" {
  description = "AWS account ID."
  value       = data.aws_quicksight_data_set.this.aws_account_id
}

output "data_set_id" {
  description = "Identifier for the data set."
  value       = data.aws_quicksight_data_set.this.data_set_id
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_quicksight_data_set.this.region
}