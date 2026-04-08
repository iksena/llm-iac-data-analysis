output "alternate_path_hints" {
  description = "Potential intermediate components of a feasible path"
  value       = aws_ec2_network_insights_analysis.this.alternate_path_hints
}

output "arn" {
  description = "ARN of the Network Insights Analysis"
  value       = aws_ec2_network_insights_analysis.this.arn
}

output "explanations" {
  description = "Explanation codes for an unreachable path"
  value       = aws_ec2_network_insights_analysis.this.explanations
}

output "forward_path_components" {
  description = "The components in the path from source to destination"
  value       = aws_ec2_network_insights_analysis.this.forward_path_components
}

output "id" {
  description = "ID of the Network Insights Analysis"
  value       = aws_ec2_network_insights_analysis.this.id
}

output "path_found" {
  description = "Set to true if the destination was reachable"
  value       = aws_ec2_network_insights_analysis.this.path_found
}

output "return_path_components" {
  description = "The components in the path from destination to source"
  value       = aws_ec2_network_insights_analysis.this.return_path_components
}

output "start_date" {
  description = "The date/time the analysis was started"
  value       = aws_ec2_network_insights_analysis.this.start_date
}

output "status" {
  description = "The status of the analysis. succeeded means the analysis was completed, not that a path was found, for that see path_found"
  value       = aws_ec2_network_insights_analysis.this.status
}

output "status_message" {
  description = "A message to provide more context when the status is failed"
  value       = aws_ec2_network_insights_analysis.this.status_message
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_ec2_network_insights_analysis.this.tags_all
}

output "warning_message" {
  description = "The warning message"
  value       = aws_ec2_network_insights_analysis.this.warning_message
}