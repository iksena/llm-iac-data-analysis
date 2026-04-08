output "arn" {
  description = "The Amazon Resource Name (ARN) of the VPC Ingress Connection."
  value       = aws_apprunner_vpc_ingress_connection.this.arn
}

output "domain_name" {
  description = "The domain name associated with the VPC Ingress Connection resource."
  value       = aws_apprunner_vpc_ingress_connection.this.domain_name
}

output "status" {
  description = "The current status of the VPC Ingress Connection."
  value       = aws_apprunner_vpc_ingress_connection.this.status
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_apprunner_vpc_ingress_connection.this.tags_all
}