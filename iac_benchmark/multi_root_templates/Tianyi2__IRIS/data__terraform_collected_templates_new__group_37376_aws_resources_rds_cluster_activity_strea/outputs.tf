output "id" {
  description = "The Amazon Resource Name (ARN) of the DB cluster."
  value       = aws_rds_cluster_activity_stream.this.id
}

output "kinesis_stream_name" {
  description = "The name of the Amazon Kinesis data stream to be used for the database activity stream."
  value       = aws_rds_cluster_activity_stream.this.kinesis_stream_name
}