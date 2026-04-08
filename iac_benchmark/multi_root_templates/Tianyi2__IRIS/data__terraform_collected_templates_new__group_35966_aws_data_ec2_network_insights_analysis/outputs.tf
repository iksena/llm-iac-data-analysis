output "alternate_path_hints" {
  description = "Potential intermediate components of a feasible path."
  value       = data.aws_ec2_network_insights_analysis.this.alternate_path_hints
}

output "arn" {
  description = "ARN of the selected Network Insights Analysis."
  value       = data.aws_ec2_network_insights_analysis.this.arn
}

output "explanations" {
  description = "Explanation codes for an unreachable path."
  value       = data.aws_ec2_network_insights_analysis.this.explanations
}

output "filter_in_arns" {
  description = "ARNs of the AWS resources that the path must traverse."
  value       = data.aws_ec2_network_insights_analysis.this.filter_in_arns
}

output "forward_path_components" {
  description = "The components in the path from source to destination."
  value       = data.aws_ec2_network_insights_analysis.this.forward_path_components
}

output "network_insights_analysis_id" {
  description = "ID of the Network Insights Analysis."
  value       = data.aws_ec2_network_insights_analysis.this.network_insights_analysis_id
}

output "network_insights_path_id" {
  description = "The ID of the path."
  value       = data.aws_ec2_network_insights_analysis.this.network_insights_path_id
}

output "path_found" {
  description = "Set to true if the destination was reachable."
  value       = data.aws_ec2_network_insights_analysis.this.path_found
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_ec2_network_insights_analysis.this.region
}

output "return_path_components" {
  description = "The components in the path from destination to source."
  value       = data.aws_ec2_network_insights_analysis.this.return_path_components
}

output "start_date" {
  description = "Date/time the analysis was started."
  value       = data.aws_ec2_network_insights_analysis.this.start_date
}

output "status" {
  description = "Status of the analysis. succeeded means the analysis was completed, not that a path was found."
  value       = data.aws_ec2_network_insights_analysis.this.status
}

output "status_message" {
  description = "Message to provide more context when the status is failed."
  value       = data.aws_ec2_network_insights_analysis.this.status_message
}

output "warning_message" {
  description = "Warning message."
  value       = data.aws_ec2_network_insights_analysis.this.warning_message
}