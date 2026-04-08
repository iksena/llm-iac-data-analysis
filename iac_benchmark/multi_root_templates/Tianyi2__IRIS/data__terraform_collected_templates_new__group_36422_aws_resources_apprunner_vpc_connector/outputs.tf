output "arn" {
  description = "ARN of VPC connector."
  value       = aws_apprunner_vpc_connector.this.arn
}

output "status" {
  description = "Current state of the VPC connector. If the status of a connector revision is INACTIVE, it was deleted and can't be used. Inactive connector revisions are permanently removed some time after they are deleted."
  value       = aws_apprunner_vpc_connector.this.status
}

output "vpc_connector_revision" {
  description = "The revision of VPC connector. It's unique among all the active connectors (Status: ACTIVE) that share the same Name."
  value       = aws_apprunner_vpc_connector.this.vpc_connector_revision
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_apprunner_vpc_connector.this.tags_all
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_apprunner_vpc_connector.this.region
}

output "vpc_connector_name" {
  description = "Name for the VPC connector."
  value       = aws_apprunner_vpc_connector.this.vpc_connector_name
}

output "subnets" {
  description = "List of IDs of subnets that App Runner uses when it associates your service with a custom Amazon VPC."
  value       = aws_apprunner_vpc_connector.this.subnets
}

output "security_groups" {
  description = "List of IDs of security groups that App Runner uses for access to AWS resources under the specified subnets."
  value       = aws_apprunner_vpc_connector.this.security_groups
}

output "tags" {
  description = "Key-value map of resource tags."
  value       = aws_apprunner_vpc_connector.this.tags
}