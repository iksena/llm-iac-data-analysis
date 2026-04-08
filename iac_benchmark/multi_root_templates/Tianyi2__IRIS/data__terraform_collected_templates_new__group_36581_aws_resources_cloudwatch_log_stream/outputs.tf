output "arn" {
  description = "The Amazon Resource Name (ARN) specifying the log stream."
  value       = aws_cloudwatch_log_stream.this.arn
}