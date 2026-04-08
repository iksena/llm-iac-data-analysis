output "s3_state_bucket_arn" {
  value       = module.terraform_state.s3_bucket_arn
  description = "The ARN of the S3 state bucket"
}

output "s3_state_bucket_id" {
  value       = module.terraform_state.s3_bucket_id
  description = "The ID of the S3 state bucket"
}

output "s3_logging_bucket_arn" {
  value       = module.terraform_state.s3_bucket_arn
  description = "The ARN of the S3 logging bucket"
}

output "dynamodb_table_arn" {
  value       = var.create_dynamodb_table ? aws_dynamodb_table.terraform_locks[0].arn : null
  description = "The ARN of the DynamoDB table (null when create_dynamodb_table is false)"
}

output "dynamodb_table_name" {
  value       = var.create_dynamodb_table ? aws_dynamodb_table.terraform_locks[0].name : null
  description = "The name of the DynamoDB table (null when create_dynamodb_table is false)"
}
