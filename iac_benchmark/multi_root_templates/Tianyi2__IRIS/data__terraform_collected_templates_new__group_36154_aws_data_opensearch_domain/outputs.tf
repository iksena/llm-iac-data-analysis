output "access_policies" {
  description = "Policy document attached to the domain"
  value       = data.aws_opensearch_domain.this.access_policies
}

output "advanced_options" {
  description = "Key-value string pairs to specify advanced configuration options"
  value       = data.aws_opensearch_domain.this.advanced_options
}

output "advanced_security_options" {
  description = "Status of the OpenSearch domain's advanced security options"
  value       = data.aws_opensearch_domain.this.advanced_security_options
}

output "arn" {
  description = "ARN of the domain"
  value       = data.aws_opensearch_domain.this.arn
}

output "auto_tune_options" {
  description = "Configuration of the Auto-Tune options of the domain"
  value       = data.aws_opensearch_domain.this.auto_tune_options
}

output "cluster_config" {
  description = "Cluster configuration of the domain"
  value       = data.aws_opensearch_domain.this.cluster_config
}

output "cognito_options" {
  description = "Domain Amazon Cognito Authentication options for Dashboard"
  value       = data.aws_opensearch_domain.this.cognito_options
}

output "created" {
  description = "Status of the creation of the domain"
  value       = data.aws_opensearch_domain.this.created
}

output "dashboard_endpoint" {
  description = "Domain-specific endpoint used to access the Dashboard application"
  value       = data.aws_opensearch_domain.this.dashboard_endpoint
}

output "dashboard_endpoint_v2" {
  description = "V2 domain-specific endpoint used to access the Dashboard application"
  value       = data.aws_opensearch_domain.this.dashboard_endpoint_v2
}

output "deleted" {
  description = "Status of the deletion of the domain"
  value       = data.aws_opensearch_domain.this.deleted
}

output "domain_endpoint_v2_hosted_zone_id" {
  description = "Dual stack hosted zone ID for the domain"
  value       = data.aws_opensearch_domain.this.domain_endpoint_v2_hosted_zone_id
}

output "domain_id" {
  description = "Unique identifier for the domain"
  value       = data.aws_opensearch_domain.this.domain_id
}

output "domain_name" {
  description = "Name of the domain"
  value       = data.aws_opensearch_domain.this.domain_name
}

output "ebs_options" {
  description = "EBS Options for the instances in the domain"
  value       = data.aws_opensearch_domain.this.ebs_options
}

output "engine_version" {
  description = "OpenSearch version for the domain"
  value       = data.aws_opensearch_domain.this.engine_version
}

output "encryption_at_rest" {
  description = "Domain encryption at rest related options"
  value       = data.aws_opensearch_domain.this.encryption_at_rest
}

output "endpoint" {
  description = "Domain-specific endpoint used to submit index, search, and data upload requests"
  value       = data.aws_opensearch_domain.this.endpoint
}

output "endpoint_v2" {
  description = "V2 domain-specific endpoint that works with both IPv4 and IPv6 addresses, used to submit index, search, and data upload requests"
  value       = data.aws_opensearch_domain.this.endpoint_v2
}

output "ip_address_type" {
  description = "Type of IP addresses supported by the endpoint for the domain"
  value       = data.aws_opensearch_domain.this.ip_address_type
}

output "log_publishing_options" {
  description = "Domain log publishing related options"
  value       = data.aws_opensearch_domain.this.log_publishing_options
}

output "node_to_node_encryption" {
  description = "Domain in transit encryption related options"
  value       = data.aws_opensearch_domain.this.node_to_node_encryption
}

output "off_peak_window_options" {
  description = "Off Peak update options"
  value       = data.aws_opensearch_domain.this.off_peak_window_options
}

output "processing" {
  description = "Status of a configuration change in the domain"
  value       = data.aws_opensearch_domain.this.processing
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_opensearch_domain.this.region
}

output "snapshot_options" {
  description = "Domain snapshot related options"
  value       = data.aws_opensearch_domain.this.snapshot_options
}

output "software_update_options" {
  description = "Software update options for the domain"
  value       = data.aws_opensearch_domain.this.software_update_options
}

output "tags" {
  description = "Tags assigned to the domain"
  value       = data.aws_opensearch_domain.this.tags
}

output "vpc_options" {
  description = "VPC Options for private OpenSearch domains"
  value       = data.aws_opensearch_domain.this.vpc_options
}