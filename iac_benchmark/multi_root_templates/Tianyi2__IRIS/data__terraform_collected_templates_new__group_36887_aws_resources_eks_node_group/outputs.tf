output "arn" {
  description = "Amazon Resource Name (ARN) of the EKS Node Group"
  value       = aws_eks_node_group.this.arn
}

output "id" {
  description = "EKS Cluster name and EKS Node Group name separated by a colon (:)"
  value       = aws_eks_node_group.this.id
}

output "resources" {
  description = "List of objects containing information about underlying resources"
  value       = aws_eks_node_group.this.resources
}

output "autoscaling_groups" {
  description = "List of objects containing information about AutoScaling Groups"
  value       = try(aws_eks_node_group.this.resources[0].autoscaling_groups, [])
}

output "remote_access_security_group_id" {
  description = "Identifier of the remote access EC2 Security Group"
  value       = try(aws_eks_node_group.this.resources[0].remote_access_security_group_id, null)
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_eks_node_group.this.tags_all
}

output "status" {
  description = "Status of the EKS Node Group"
  value       = aws_eks_node_group.this.status
}