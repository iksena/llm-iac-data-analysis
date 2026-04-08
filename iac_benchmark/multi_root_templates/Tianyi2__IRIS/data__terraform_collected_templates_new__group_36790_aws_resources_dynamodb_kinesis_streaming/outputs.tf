output "id" {
  description = "The table_name and stream_arn separated by a comma (,)."
  value       = aws_dynamodb_kinesis_streaming_destination.this.id
}