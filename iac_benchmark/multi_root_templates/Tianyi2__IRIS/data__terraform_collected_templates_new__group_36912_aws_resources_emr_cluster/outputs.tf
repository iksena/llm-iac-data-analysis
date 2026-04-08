output "applications" {
  description = "Applications installed on this cluster."
  value       = aws_emr_cluster.this.applications
}

output "arn" {
  description = "ARN of the cluster."
  value       = aws_emr_cluster.this.arn
}

output "bootstrap_action" {
  description = "List of bootstrap actions that will be run before Hadoop is started on the cluster nodes."
  value       = aws_emr_cluster.this.bootstrap_action
}

output "configurations" {
  description = "List of Configurations supplied to the EMR cluster."
  value       = aws_emr_cluster.this.configurations
}

output "core_instance_group_id" {
  description = "Core node type Instance Group ID, if using Instance Group for this node type."
  value       = try(aws_emr_cluster.this.core_instance_group.0.id, null)
}

output "ec2_attributes" {
  description = "Provides information about the EC2 instances in a cluster grouped by category: key name, subnet ID, IAM instance profile, and so on."
  value       = aws_emr_cluster.this.ec2_attributes
}

output "id" {
  description = "ID of the cluster."
  value       = aws_emr_cluster.this.id
}

output "log_uri" {
  description = "Path to the Amazon S3 location where logs for this cluster are stored."
  value       = aws_emr_cluster.this.log_uri
}

output "master_instance_group_id" {
  description = "Master node type Instance Group ID, if using Instance Group for this node type."
  value       = try(aws_emr_cluster.this.master_instance_group.0.id, null)
}

output "master_public_dns" {
  description = "The DNS name of the master node. If the cluster is on a private subnet, this is the private DNS name. On a public subnet, this is the public DNS name."
  value       = aws_emr_cluster.this.master_public_dns
}

output "name" {
  description = "Name of the cluster."
  value       = aws_emr_cluster.this.name
}

output "release_label" {
  description = "Release label for the Amazon EMR release."
  value       = aws_emr_cluster.this.release_label
}

output "service_role" {
  description = "IAM role that will be assumed by the Amazon EMR service to access AWS resources on your behalf."
  value       = aws_emr_cluster.this.service_role
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_emr_cluster.this.tags_all
}