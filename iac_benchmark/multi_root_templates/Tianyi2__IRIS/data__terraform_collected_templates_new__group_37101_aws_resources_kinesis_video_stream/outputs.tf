output "id" {
  description = "The unique Stream id"
  value       = aws_kinesis_video_stream.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) specifying the Stream (same as id)"
  value       = aws_kinesis_video_stream.this.arn
}

output "creation_time" {
  description = "A time stamp that indicates when the stream was created"
  value       = aws_kinesis_video_stream.this.creation_time
}

output "version" {
  description = "The version of the stream"
  value       = aws_kinesis_video_stream.this.version
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_kinesis_video_stream.this.tags_all
}