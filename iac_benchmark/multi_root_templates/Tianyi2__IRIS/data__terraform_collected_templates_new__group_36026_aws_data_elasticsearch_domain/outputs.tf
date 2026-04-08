output "access_policies" {
  description = "The policy document attached to the domain"
  value       = data.aws_elasticsearch_domain.this.access_policies
}

output "advanced_options" {
  description = "Key-value string pairs to specify advanced configuration options"
  value       = data.aws_elasticsearch_domain.this.advanced_options
}

output "advanced_security_options" {
  description = "Status of the Elasticsearch domain's advanced security options"
  value       = data.aws_elasticsearch_domain.this.advanced_security_options
}

output "arn" {
  description = "The ARN of the domain"
  value       = data.aws_elasticsearch_domain.this.arn
}

output "auto_tune_options" {
  description = "Configuration of the Auto-Tune options of the domain"
  value       = data.aws_elasticsearch_domain.this.auto_tune_options
}

output "cluster_config" {
  description = "Cluster configuration of the domain"
  value       = data.aws_elasticsearch_domain.this.cluster_config
}

output "cognito_options" {
  description = "Domain Amazon Cognito Authentication options for Kibana"
  value       = data.aws_elasticsearch_domain.this.cognito_options
}

output "created" {
  description = "Status of the creation of the domain"
  value       = data.aws_elasticsearch_domain.this.created
}

output "deleted" {
  description = "Status of the deletion of the domain"
  value       = data.aws_elasticsearch_domain.this.deleted
}

output "domain_id" {
  description = "Unique identifier for the domain"
  value       = data.aws_elasticsearch_domain.this.domain_id
}

output "domain_name" {
  description = "Name of the domain"
  value       = data.aws_elasticsearch_domain.this.domain_name
}

output "ebs_options" {
  description = "EBS Options for the instances in the domain"
  value       = data.aws_elasticsearch_domain.this.ebs_options
}

output "elasticsearch_version" {
  description = "Elasticsearch version for the domain"
  value       = data.aws_elasticsearch_domain.this.elasticsearch_version
}

output "encryption_at_rest" {
  description = "Domain encryption at rest related options"
  value       = data.aws_elasticsearch_domain.this.encryption_at_rest
}

output "endpoint" {
  description = "Domain-specific endpoint used to submit index, search, and data upload requests"
  value       = data.aws_elasticsearch_domain.this.endpoint
}

output "kibana_endpoint" {
  description = "Domain-specific endpoint used to access the Kibana application"
  value       = data.aws_elasticsearch_domain.this.kibana_endpoint
}

output "log_publishing_options" {
  description = "Domain log publishing related options"
  value       = data.aws_elasticsearch_domain.this.log_publishing_options
}

output "node_to_node_encryption" {
  description = "Domain in transit encryption related options"
  value       = data.aws_elasticsearch_domain.this.node_to_node_encryption
}

output "processing" {
  description = "Status of a configuration change in the domain"
  value       = data.aws_elasticsearch_domain.this.processing
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_elasticsearch_domain.this.region
}

output "snapshot_options" {
  description = "Domain snapshot related options"
  value       = data.aws_elasticsearch_domain.this.snapshot_options
}

output "tags" {
  description = "Tags assigned to the domain"
  value       = data.aws_elasticsearch_domain.this.tags
}

output "vpc_options" {
  description = "VPC Options for private Elasticsearch domains"
  value       = data.aws_elasticsearch_domain.this.vpc_options
}