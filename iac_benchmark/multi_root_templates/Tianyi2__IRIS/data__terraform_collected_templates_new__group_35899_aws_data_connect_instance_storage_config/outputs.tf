output "id" {
  description = "The identifier of the hosting Amazon Connect Instance, association_id, and resource_type separated by a colon (:)"
  value       = data.aws_connect_instance_storage_config.this.id
}

output "storage_config" {
  description = "Specifies the storage configuration options for the Connect Instance"
  value       = data.aws_connect_instance_storage_config.this.storage_config
}

output "storage_config_kinesis_firehose_config" {
  description = "A block that specifies the configuration of the Kinesis Firehose delivery stream"
  value       = try(data.aws_connect_instance_storage_config.this.storage_config[0].kinesis_firehose_config, null)
}

output "storage_config_kinesis_firehose_config_firehose_arn" {
  description = "The Amazon Resource Name (ARN) of the delivery stream"
  value       = try(data.aws_connect_instance_storage_config.this.storage_config[0].kinesis_firehose_config[0].firehose_arn, null)
}

output "storage_config_kinesis_stream_config" {
  description = "A block that specifies the configuration of the Kinesis data stream"
  value       = try(data.aws_connect_instance_storage_config.this.storage_config[0].kinesis_stream_config, null)
}

output "storage_config_kinesis_stream_config_stream_arn" {
  description = "The Amazon Resource Name (ARN) of the data stream"
  value       = try(data.aws_connect_instance_storage_config.this.storage_config[0].kinesis_stream_config[0].stream_arn, null)
}

output "storage_config_kinesis_video_stream_config" {
  description = "A block that specifies the configuration of the Kinesis video stream"
  value       = try(data.aws_connect_instance_storage_config.this.storage_config[0].kinesis_video_stream_config, null)
}

output "storage_config_kinesis_video_stream_config_encryption_config" {
  description = "The encryption configuration for Kinesis video stream"
  value       = try(data.aws_connect_instance_storage_config.this.storage_config[0].kinesis_video_stream_config[0].encryption_config, null)
}

output "storage_config_kinesis_video_stream_config_encryption_config_encryption_type" {
  description = "The type of encryption. Valid Values: KMS"
  value       = try(data.aws_connect_instance_storage_config.this.storage_config[0].kinesis_video_stream_config[0].encryption_config[0].encryption_type, null)
}

output "storage_config_kinesis_video_stream_config_encryption_config_key_id" {
  description = "The full ARN of the encryption key. Be sure to provide the full ARN of the encryption key, not just the ID"
  value       = try(data.aws_connect_instance_storage_config.this.storage_config[0].kinesis_video_stream_config[0].encryption_config[0].key_id, null)
}

output "storage_config_kinesis_video_stream_config_prefix" {
  description = "The prefix of the video stream. When read from the state, the value returned is <prefix>-connect-<connect_instance_alias>-contact- since the API appends additional details to the prefix"
  value       = try(data.aws_connect_instance_storage_config.this.storage_config[0].kinesis_video_stream_config[0].prefix, null)
}

output "storage_config_kinesis_video_stream_config_retention_period_hours" {
  description = "The number of hours to retain the data in a data store associated with the stream. A value of 0 indicates that the stream does not persist data"
  value       = try(data.aws_connect_instance_storage_config.this.storage_config[0].kinesis_video_stream_config[0].retention_period_hours, null)
}

output "storage_config_s3_config" {
  description = "A block that specifies the configuration of S3 Bucket"
  value       = try(data.aws_connect_instance_storage_config.this.storage_config[0].s3_config, null)
}

output "storage_config_s3_config_bucket_name" {
  description = "The S3 bucket name"
  value       = try(data.aws_connect_instance_storage_config.this.storage_config[0].s3_config[0].bucket_name, null)
}

output "storage_config_s3_config_bucket_prefix" {
  description = "The S3 bucket prefix"
  value       = try(data.aws_connect_instance_storage_config.this.storage_config[0].s3_config[0].bucket_prefix, null)
}

output "storage_config_s3_config_encryption_config" {
  description = "The encryption configuration for S3"
  value       = try(data.aws_connect_instance_storage_config.this.storage_config[0].s3_config[0].encryption_config, null)
}

output "storage_config_s3_config_encryption_config_encryption_type" {
  description = "The type of encryption. Valid Values: KMS"
  value       = try(data.aws_connect_instance_storage_config.this.storage_config[0].s3_config[0].encryption_config[0].encryption_type, null)
}

output "storage_config_s3_config_encryption_config_key_id" {
  description = "The full ARN of the encryption key. Be sure to provide the full ARN of the encryption key, not just the ID"
  value       = try(data.aws_connect_instance_storage_config.this.storage_config[0].s3_config[0].encryption_config[0].key_id, null)
}

output "storage_config_storage_type" {
  description = "A valid storage type. Valid Values: S3, KINESIS_VIDEO_STREAM, KINESIS_STREAM, KINESIS_FIREHOSE"
  value       = try(data.aws_connect_instance_storage_config.this.storage_config[0].storage_type, null)
}