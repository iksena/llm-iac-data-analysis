output "graph_arn" {
  description = "ARN of the Detective Graph."
  value       = aws_detective_graph.this.graph_arn
}

output "created_time" {
  description = "Date and time, in UTC and extended RFC 3339 format, when the Amazon Detective Graph was created."
  value       = aws_detective_graph.this.created_time
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_detective_graph.this.region
}

output "tags" {
  description = "A map of tags assigned to the resource."
  value       = aws_detective_graph.this.tags
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_detective_graph.this.tags_all
}