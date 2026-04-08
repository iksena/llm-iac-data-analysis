output "arn" {
  description = "ARN of the Stream Processor."
  value       = aws_rekognition_stream_processor.this.arn
}

output "stream_processor_arn" {
  description = "ARN of the Stream Processor. (Deprecated - use arn instead)"
  value       = aws_rekognition_stream_processor.this.stream_processor_arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_rekognition_stream_processor.this.tags_all
}