output "arn" {
  description = "Amazon Resource Name (ARN) of the MSK cluster"
  value       = aws_msk_cluster.this.arn
}

output "bootstrap_brokers" {
  description = "Comma separated list of one or more hostname:port pairs of kafka brokers suitable to bootstrap connectivity to the kafka cluster"
  value       = aws_msk_cluster.this.bootstrap_brokers
}

output "bootstrap_brokers_public_sasl_iam" {
  description = "One or more DNS names (or IP addresses) and SASL IAM port pairs for public access"
  value       = aws_msk_cluster.this.bootstrap_brokers_public_sasl_iam
}

output "bootstrap_brokers_public_sasl_scram" {
  description = "One or more DNS names (or IP addresses) and SASL SCRAM port pairs for public access"
  value       = aws_msk_cluster.this.bootstrap_brokers_public_sasl_scram
}

output "bootstrap_brokers_public_tls" {
  description = "One or more DNS names (or IP addresses) and TLS port pairs for public access"
  value       = aws_msk_cluster.this.bootstrap_brokers_public_tls
}

output "bootstrap_brokers_sasl_iam" {
  description = "One or more DNS names (or IP addresses) and SASL IAM port pairs"
  value       = aws_msk_cluster.this.bootstrap_brokers_sasl_iam
}

output "bootstrap_brokers_sasl_scram" {
  description = "One or more DNS names (or IP addresses) and SASL SCRAM port pairs"
  value       = aws_msk_cluster.this.bootstrap_brokers_sasl_scram
}

output "bootstrap_brokers_tls" {
  description = "One or more DNS names (or IP addresses) and TLS port pairs"
  value       = aws_msk_cluster.this.bootstrap_brokers_tls
}

output "bootstrap_brokers_vpc_connectivity_sasl_iam" {
  description = "A string containing one or more DNS names (or IP addresses) and SASL IAM port pairs for VPC connectivity"
  value       = aws_msk_cluster.this.bootstrap_brokers_vpc_connectivity_sasl_iam
}

output "bootstrap_brokers_vpc_connectivity_sasl_scram" {
  description = "A string containing one or more DNS names (or IP addresses) and SASL SCRAM port pairs for VPC connectivity"
  value       = aws_msk_cluster.this.bootstrap_brokers_vpc_connectivity_sasl_scram
}

output "bootstrap_brokers_vpc_connectivity_tls" {
  description = "A string containing one or more DNS names (or IP addresses) and TLS port pairs for VPC connectivity"
  value       = aws_msk_cluster.this.bootstrap_brokers_vpc_connectivity_tls
}

output "cluster_uuid" {
  description = "UUID of the MSK cluster, for use in IAM policies"
  value       = aws_msk_cluster.this.cluster_uuid
}

output "current_version" {
  description = "Current version of the MSK Cluster used for updates"
  value       = aws_msk_cluster.this.current_version
}

output "encryption_info_encryption_at_rest_kms_key_arn" {
  description = "The ARN of the KMS key used for encryption at rest of the broker data volumes"
  value       = aws_msk_cluster.this.encryption_info[0].encryption_at_rest_kms_key_arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_msk_cluster.this.tags_all
}

output "zookeeper_connect_string" {
  description = "A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster"
  value       = aws_msk_cluster.this.zookeeper_connect_string
}

output "zookeeper_connect_string_tls" {
  description = "A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster via TLS"
  value       = aws_msk_cluster.this.zookeeper_connect_string_tls
}