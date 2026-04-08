output "arn" {
  description = "ARN of the log anomaly detector that you just created."
  value       = aws_cloudwatch_log_anomaly_detector.this.arn
}