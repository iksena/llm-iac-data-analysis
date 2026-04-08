output "arn" {
  description = "ARN of the anomaly monitor."
  value       = aws_ce_anomaly_monitor.this.arn
}

output "id" {
  description = "Unique ID of the anomaly monitor. Same as arn."
  value       = aws_ce_anomaly_monitor.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ce_anomaly_monitor.this.tags_all
}