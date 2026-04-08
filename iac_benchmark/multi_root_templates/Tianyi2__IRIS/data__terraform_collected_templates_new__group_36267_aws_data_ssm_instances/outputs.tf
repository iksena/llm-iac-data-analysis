output "ids" {
  description = "Set of instance IDs of the matched SSM managed instances."
  value       = data.aws_ssm_instances.this.ids
}

output "region" {
  description = "The AWS region where the SSM instances are managed."
  value       = data.aws_ssm_instances.this.region
}

output "filter" {
  description = "The filter configuration blocks used to query SSM instances."
  value       = var.filter
}