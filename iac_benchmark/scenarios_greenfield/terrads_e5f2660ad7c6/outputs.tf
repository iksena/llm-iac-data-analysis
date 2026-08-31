output "state_bucket_arn" {
  value = aws_s3_bucket.backend.arn
}

output "dynamo_lock_table" {
  value = aws_dynamodb_table.lock.id
}
