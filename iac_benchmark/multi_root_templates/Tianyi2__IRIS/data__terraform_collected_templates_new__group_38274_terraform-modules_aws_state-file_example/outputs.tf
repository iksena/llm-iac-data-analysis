output "aws_s3_bucket" {
  value       = module.example.s3_state_bucket_id
  description = "The ID of the S3 bucket"
}

output "dynamodb_table_name" {
  value       = module.example.dynamodb_table_name
  description = "The ARN of the DynamoDB table"
}