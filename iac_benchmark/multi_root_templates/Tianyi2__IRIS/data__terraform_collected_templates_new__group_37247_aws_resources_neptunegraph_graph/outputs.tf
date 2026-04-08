output "endpoint" {
  description = "The connection endpoint for the graph. For example: g-12a3bcdef4.us-east-1.neptune-graph.amazonaws.com"
  value       = aws_neptunegraph_graph.this.endpoint
}

output "arn" {
  description = "Graph resource ARN"
  value       = aws_neptunegraph_graph.this.arn
}

output "id" {
  description = "The auto-generated id assigned by the service"
  value       = aws_neptunegraph_graph.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_neptunegraph_graph.this.tags_all
}