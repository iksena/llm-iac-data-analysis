output "arn" {
  description = "ARN of the cluster"
  value       = aws_route53recoverycontrolconfig_cluster.this.arn
}

output "cluster_endpoints" {
  description = "List of 5 endpoints in 5 regions that can be used to talk to the cluster"
  value       = aws_route53recoverycontrolconfig_cluster.this.cluster_endpoints
}

output "status" {
  description = "Status of cluster. PENDING when it is being created, PENDING_DELETION when it is being deleted and DEPLOYED otherwise"
  value       = aws_route53recoverycontrolconfig_cluster.this.status
}