output "arn" {
  description = "ARN of the archive."
  value       = aws_cloudwatch_event_archive.this.arn
}