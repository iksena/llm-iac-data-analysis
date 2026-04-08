output "arn" {
  description = "ARN of the entity."
  value       = data.aws_wafv2_web_acl.this.arn
}

output "description" {
  description = "Description of the WebACL that helps with identification."
  value       = data.aws_wafv2_web_acl.this.description
}

output "id" {
  description = "Unique identifier of the WebACL."
  value       = data.aws_wafv2_web_acl.this.id
}

output "name" {
  description = "Name of the WAFv2 Web ACL."
  value       = data.aws_wafv2_web_acl.this.name
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_wafv2_web_acl.this.region
}

output "resource_arn" {
  description = "ARN of the AWS resource associated with the Web ACL."
  value       = data.aws_wafv2_web_acl.this.resource_arn
}

output "scope" {
  description = "Scope of the WAFv2 Web ACL (CLOUDFRONT or REGIONAL)."
  value       = data.aws_wafv2_web_acl.this.scope
}