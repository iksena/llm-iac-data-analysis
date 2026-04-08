output "arn" {
  description = "ARN of the MSK cluster."
  value       = data.aws_msk_cluster.this.arn
}

output "bootstrap_brokers" {
  description = "Comma separated list of one or more hostname:port pairs of kafka brokers suitable to bootstrap connectivity to the kafka cluster."
  value       = data.aws_msk_cluster.this.bootstrap_brokers
}

output "bootstrap_brokers_public_sasl_iam" {
  description = "One or more DNS names (or IP addresses) and SASL IAM port pairs for public access."
  value       = data.aws_msk_cluster.this.bootstrap_brokers_public_sasl_iam
}

output "bootstrap_brokers_public_sasl_scram" {
  description = "One or more DNS names (or IP addresses) and SASL SCRAM port pairs for public access."
  value       = data.aws_msk_cluster.this.bootstrap_brokers_public_sasl_scram
}

output "bootstrap_brokers_public_tls" {
  description = "One or more DNS names (or IP addresses) and TLS port pairs for public access."
  value       = data.aws_msk_cluster.this.bootstrap_brokers_public_tls
}

output "bootstrap_brokers_sasl_iam" {
  description = "One or more DNS names (or IP addresses) and SASL IAM port pairs."
  value       = data.aws_msk_cluster.this.bootstrap_brokers_sasl_iam
}

output "bootstrap_brokers_sasl_scram" {
  description = "One or more DNS names (or IP addresses) and SASL SCRAM port pairs."
  value       = data.aws_msk_cluster.this.bootstrap_brokers_sasl_scram
}

output "bootstrap_brokers_tls" {
  description = "One or more DNS names (or IP addresses) and TLS port pairs."
  value       = data.aws_msk_cluster.this.bootstrap_brokers_tls
}

output "broker_node_group_info" {
  description = "Configuration block for the broker nodes of the Kafka cluster."
  value       = data.aws_msk_cluster.this.broker_node_group_info
}

output "cluster_uuid" {
  description = "UUID of the MSK cluster, for use in IAM policies."
  value       = data.aws_msk_cluster.this.cluster_uuid
}

output "kafka_version" {
  description = "Apache Kafka version."
  value       = data.aws_msk_cluster.this.kafka_version
}

output "number_of_broker_nodes" {
  description = "Number of broker nodes in the cluster."
  value       = data.aws_msk_cluster.this.number_of_broker_nodes
}

output "tags" {
  description = "Map of key-value pairs assigned to the cluster."
  value       = data.aws_msk_cluster.this.tags
}

output "zookeeper_connect_string" {
  description = "A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster."
  value       = data.aws_msk_cluster.this.zookeeper_connect_string
}

output "zookeeper_connect_string_tls" {
  description = "A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster via TLS."
  value       = data.aws_msk_cluster.this.zookeeper_connect_string_tls
}