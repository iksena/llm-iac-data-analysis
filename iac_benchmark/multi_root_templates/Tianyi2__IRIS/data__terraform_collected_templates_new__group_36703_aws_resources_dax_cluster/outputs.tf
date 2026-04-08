output "arn" {
  description = "The ARN of the DAX cluster"
  value       = aws_dax_cluster.this.arn
}

output "nodes" {
  description = "List of node objects including id, address, port and availability_zone"
  value       = aws_dax_cluster.this.nodes
}

output "configuration_endpoint" {
  description = "The configuration endpoint for this DAX cluster, consisting of a DNS name and a port number"
  value       = aws_dax_cluster.this.configuration_endpoint
}

output "cluster_address" {
  description = "The DNS name of the DAX cluster without the port appended"
  value       = aws_dax_cluster.this.cluster_address
}

output "port" {
  description = "The port used by the configuration endpoint"
  value       = aws_dax_cluster.this.port
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_dax_cluster.this.tags_all
}