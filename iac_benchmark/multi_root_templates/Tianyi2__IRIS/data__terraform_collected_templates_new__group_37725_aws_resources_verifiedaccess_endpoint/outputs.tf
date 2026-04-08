output "attachment_type" {
  description = "The type of attachment."
  value       = aws_verifiedaccess_endpoint.this.attachment_type
}

output "endpoint_domain_prefix" {
  description = "A custom identifier that is prepended to the DNS name that is generated for the endpoint."
  value       = aws_verifiedaccess_endpoint.this.endpoint_domain_prefix
}

output "endpoint_type" {
  description = "The type of Verified Access endpoint."
  value       = aws_verifiedaccess_endpoint.this.endpoint_type
}

output "verified_access_group_id" {
  description = "The ID of the Verified Access group associated with the endpoint."
  value       = aws_verifiedaccess_endpoint.this.verified_access_group_id
}

output "region" {
  description = "Region where the resource is managed."
  value       = aws_verifiedaccess_endpoint.this.region
}

output "application_domain" {
  description = "The DNS name for users to reach your application."
  value       = aws_verifiedaccess_endpoint.this.application_domain
}

output "description" {
  description = "A description for the Verified Access endpoint."
  value       = aws_verifiedaccess_endpoint.this.description
}

output "domain_certificate_arn" {
  description = "The ARN of the public TLS/SSL certificate in AWS Certificate Manager associated with the endpoint."
  value       = aws_verifiedaccess_endpoint.this.domain_certificate_arn
}

output "policy_document" {
  description = "The policy document that is associated with this resource."
  value       = aws_verifiedaccess_endpoint.this.policy_document
}

output "security_group_ids" {
  description = "List of the security groups IDs associated with the Verified Access endpoint."
  value       = aws_verifiedaccess_endpoint.this.security_group_ids
}

output "sse_specification" {
  description = "The options in use for server side encryption."
  value       = aws_verifiedaccess_endpoint.this.sse_specification
}

output "load_balancer_options" {
  description = "The load balancer details."
  value       = aws_verifiedaccess_endpoint.this.load_balancer_options
}

output "network_interface_options" {
  description = "The network interface details."
  value       = aws_verifiedaccess_endpoint.this.network_interface_options
}

output "cidr_options" {
  description = "The CIDR block details."
  value       = aws_verifiedaccess_endpoint.this.cidr_options
}

output "tags" {
  description = "Key-value tags for the Verified Access Endpoint."
  value       = aws_verifiedaccess_endpoint.this.tags
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_verifiedaccess_endpoint.this.tags_all
}

output "device_validation_domain" {
  description = "Returned if endpoint has a device trust provider attached."
  value       = aws_verifiedaccess_endpoint.this.device_validation_domain
}

output "endpoint_domain" {
  description = "A DNS name that is generated for the endpoint."
  value       = aws_verifiedaccess_endpoint.this.endpoint_domain
}

output "id" {
  description = "The ID of the AWS Verified Access endpoint."
  value       = aws_verifiedaccess_endpoint.this.id
}