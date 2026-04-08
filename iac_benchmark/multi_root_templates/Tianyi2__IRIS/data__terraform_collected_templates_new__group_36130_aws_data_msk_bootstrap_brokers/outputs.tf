output "bootstrap_brokers" {
  description = "Comma separated list of one or more hostname:port pairs of kafka brokers suitable to bootstrap connectivity to the kafka cluster."
  value       = data.aws_msk_bootstrap_brokers.this.bootstrap_brokers
}

output "bootstrap_brokers_public_sasl_iam" {
  description = "One or more DNS names (or IP addresses) and SASL IAM port pairs."
  value       = data.aws_msk_bootstrap_brokers.this.bootstrap_brokers_public_sasl_iam
}

output "bootstrap_brokers_public_sasl_scram" {
  description = "One or more DNS names (or IP addresses) and SASL SCRAM port pairs."
  value       = data.aws_msk_bootstrap_brokers.this.bootstrap_brokers_public_sasl_scram
}

output "bootstrap_brokers_public_tls" {
  description = "One or more DNS names (or IP addresses) and TLS port pairs."
  value       = data.aws_msk_bootstrap_brokers.this.bootstrap_brokers_public_tls
}

output "bootstrap_brokers_sasl_iam" {
  description = "One or more DNS names (or IP addresses) and SASL IAM port pairs."
  value       = data.aws_msk_bootstrap_brokers.this.bootstrap_brokers_sasl_iam
}

output "bootstrap_brokers_sasl_scram" {
  description = "One or more DNS names (or IP addresses) and SASL SCRAM port pairs."
  value       = data.aws_msk_bootstrap_brokers.this.bootstrap_brokers_sasl_scram
}

output "bootstrap_brokers_tls" {
  description = "One or more DNS names (or IP addresses) and TLS port pairs."
  value       = data.aws_msk_bootstrap_brokers.this.bootstrap_brokers_tls
}

output "bootstrap_brokers_vpc_connectivity_sasl_iam" {
  description = "A string containing one or more DNS names (or IP addresses) and SASL IAM port pairs for VPC connectivity."
  value       = data.aws_msk_bootstrap_brokers.this.bootstrap_brokers_vpc_connectivity_sasl_iam
}

output "bootstrap_brokers_vpc_connectivity_sasl_scram" {
  description = "A string containing one or more DNS names (or IP addresses) and SASL SCRAM port pairs for VPC connectivity."
  value       = data.aws_msk_bootstrap_brokers.this.bootstrap_brokers_vpc_connectivity_sasl_scram
}

output "bootstrap_brokers_vpc_connectivity_tls" {
  description = "A string containing one or more DNS names (or IP addresses) and TLS port pairs for VPC connectivity."
  value       = data.aws_msk_bootstrap_brokers.this.bootstrap_brokers_vpc_connectivity_tls
}