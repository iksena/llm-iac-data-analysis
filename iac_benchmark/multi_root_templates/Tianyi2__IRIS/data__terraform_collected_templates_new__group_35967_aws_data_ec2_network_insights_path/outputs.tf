output "arn" {
  description = "ARN of the selected Network Insights Path."
  value       = data.aws_ec2_network_insights_path.this.arn
}

output "destination" {
  description = "AWS resource that is the destination of the path."
  value       = data.aws_ec2_network_insights_path.this.destination
}

output "destination_arn" {
  description = "ARN of the destination."
  value       = data.aws_ec2_network_insights_path.this.destination_arn
}

output "destination_ip" {
  description = "IP address of the AWS resource that is the destination of the path."
  value       = data.aws_ec2_network_insights_path.this.destination_ip
}

output "destination_port" {
  description = "Destination port."
  value       = data.aws_ec2_network_insights_path.this.destination_port
}

output "filter_at_destination" {
  description = "Filters of the network paths at the destination."
  value       = data.aws_ec2_network_insights_path.this.filter_at_destination
}

output "filter_at_source" {
  description = "Filters of the network paths at the source."
  value       = data.aws_ec2_network_insights_path.this.filter_at_source
}

output "protocol" {
  description = "Protocol."
  value       = data.aws_ec2_network_insights_path.this.protocol
}

output "source" {
  description = "AWS resource that is the source of the path."
  value       = data.aws_ec2_network_insights_path.this.source
}

output "source_arn" {
  description = "ARN of the source."
  value       = data.aws_ec2_network_insights_path.this.source_arn
}

output "source_ip" {
  description = "IP address of the AWS resource that is the source of the path."
  value       = data.aws_ec2_network_insights_path.this.source_ip
}

output "tags" {
  description = "Map of tags assigned to the resource."
  value       = data.aws_ec2_network_insights_path.this.tags
}