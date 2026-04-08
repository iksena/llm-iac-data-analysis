
output "clusters" {
  description = "List of DSQL Cluster ARNs peered to this cluster"
  value       = aws_dsql_cluster_peering.this.clusters
}

output "identifier" {
  description = "DSQL Cluster Identifier"
  value       = aws_dsql_cluster_peering.this.identifier
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_dsql_cluster_peering.this.region
}

output "witness_region" {
  description = "Witness region for the multi-region cluster"
  value       = aws_dsql_cluster_peering.this.witness_region
}