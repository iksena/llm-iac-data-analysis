output "id" {
  description = "The name of the CloudWatch RUM app monitor that will send the metrics."
  value       = aws_rum_metrics_destination.this.id
}