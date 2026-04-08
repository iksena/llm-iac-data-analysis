output "id" {
  description = "The ID of the Elastictranscoder pipeline."
  value       = aws_elastictranscoder_pipeline.this.id
}

output "arn" {
  description = "The ARN of the Elastictranscoder pipeline."
  value       = aws_elastictranscoder_pipeline.this.arn
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_elastictranscoder_pipeline.this.region
}

output "aws_kms_key_arn" {
  description = "The AWS Key Management Service (AWS KMS) key used with this pipeline."
  value       = aws_elastictranscoder_pipeline.this.aws_kms_key_arn
}

output "input_bucket" {
  description = "The Amazon S3 bucket with the media files to transcode."
  value       = aws_elastictranscoder_pipeline.this.input_bucket
}

output "name" {
  description = "The name of the pipeline."
  value       = aws_elastictranscoder_pipeline.this.name
}

output "output_bucket" {
  description = "The Amazon S3 bucket where transcoded files are saved."
  value       = aws_elastictranscoder_pipeline.this.output_bucket
}

output "role" {
  description = "The IAM Amazon Resource Name (ARN) for the role used by Elastic Transcoder."
  value       = aws_elastictranscoder_pipeline.this.role
}

output "content_config" {
  description = "The ContentConfig object with information about the Amazon S3 bucket for transcoded files and playlists."
  value       = aws_elastictranscoder_pipeline.this.content_config
}

output "content_config_permissions" {
  description = "The permissions for the content_config object."
  value       = aws_elastictranscoder_pipeline.this.content_config_permissions
}

output "notifications" {
  description = "The Amazon Simple Notification Service (Amazon SNS) topic configuration for job status notifications."
  value       = aws_elastictranscoder_pipeline.this.notifications
}

output "thumbnail_config" {
  description = "The ThumbnailConfig object with information about the Amazon S3 bucket for thumbnail files."
  value       = aws_elastictranscoder_pipeline.this.thumbnail_config
}

output "thumbnail_config_permissions" {
  description = "The permissions for the thumbnail_config object."
  value       = aws_elastictranscoder_pipeline.this.thumbnail_config_permissions
}