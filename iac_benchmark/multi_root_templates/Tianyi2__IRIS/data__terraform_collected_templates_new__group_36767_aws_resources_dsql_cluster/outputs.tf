output "arn" {
  description = "ARN of the Cluster."
  value       = aws_dsql_cluster.this.arn
}

output "encryption_details" {
  description = "Encryption configuration details for the DSQL Cluster."
  value = {
    encryption_status = aws_dsql_cluster.this.encryption_details[0].encryption_status
    encryption_type   = aws_dsql_cluster.this.encryption_details[0].encryption_type
  }
}

output "identifier" {
  description = "Cluster Identifier."
  value       = aws_dsql_cluster.this.identifier
}

output "multi_region_properties" {
  description = "Multi-region properties of the DSQL Cluster."
  value = var.multi_region_properties != null ? {
    witness_region = aws_dsql_cluster.this.multi_region_properties[0].witness_region
    clusters       = aws_dsql_cluster.this.multi_region_properties[0].clusters
  } : null
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_dsql_cluster.this.tags_all
}

output "vpc_endpoint_service_name" {
  description = "The DSQL Cluster's VPC endpoint service name."
  value       = aws_dsql_cluster.this.vpc_endpoint_service_name
}