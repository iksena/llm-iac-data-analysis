output "id" {
  description = "The ID of the autoscaling traffic source attachment."
  value       = aws_autoscaling_traffic_source_attachment.this.id
}

output "autoscaling_group_name" {
  description = "The name of the Auto Scaling group."
  value       = aws_autoscaling_traffic_source_attachment.this.autoscaling_group_name
}

output "traffic_source" {
  description = "The traffic source configuration."
  value       = aws_autoscaling_traffic_source_attachment.this.traffic_source
}

output "region" {
  description = "The region where the resource is managed."
  value       = aws_autoscaling_traffic_source_attachment.this.region
}