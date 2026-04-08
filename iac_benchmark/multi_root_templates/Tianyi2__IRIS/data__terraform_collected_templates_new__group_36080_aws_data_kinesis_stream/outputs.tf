output "id" {
  description = "ARN of the Kinesis Stream"
  value       = data.aws_kinesis_stream.this.id
}

output "arn" {
  description = "ARN of the Kinesis Stream (same as id)"
  value       = data.aws_kinesis_stream.this.arn
}

output "closed_shards" {
  description = "List of shard ids in the CLOSED state"
  value       = data.aws_kinesis_stream.this.closed_shards
}

output "creation_timestamp" {
  description = "Approximate UNIX timestamp that the stream was created"
  value       = data.aws_kinesis_stream.this.creation_timestamp
}

output "encryption_type" {
  description = "Encryption type used"
  value       = data.aws_kinesis_stream.this.encryption_type
}

output "kms_key_id" {
  description = "GUID for the customer-managed AWS KMS key to use for encryption"
  value       = data.aws_kinesis_stream.this.kms_key_id
}

output "name" {
  description = "Name of the Kinesis Stream"
  value       = data.aws_kinesis_stream.this.name
}

output "open_shards" {
  description = "List of shard ids in the OPEN state"
  value       = data.aws_kinesis_stream.this.open_shards
}

output "retention_period" {
  description = "Length of time (in hours) data records are accessible after they are added to the stream"
  value       = data.aws_kinesis_stream.this.retention_period
}

output "shard_level_metrics" {
  description = "List of shard-level CloudWatch metrics which are enabled for the stream"
  value       = data.aws_kinesis_stream.this.shard_level_metrics
}

output "status" {
  description = "Current status of the stream. The stream status is one of CREATING, DELETING, ACTIVE, or UPDATING"
  value       = data.aws_kinesis_stream.this.status
}

output "stream_mode_details" {
  description = "Capacity mode of the data stream"
  value       = data.aws_kinesis_stream.this.stream_mode_details
}

output "tags" {
  description = "Map of tags to assigned to the stream"
  value       = data.aws_kinesis_stream.this.tags
}