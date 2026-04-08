output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_wafv2_regex_pattern_set.this.region
}

output "name" {
  description = "Name of the WAFv2 Regex Pattern Set."
  value       = data.aws_wafv2_regex_pattern_set.this.name
}

output "scope" {
  description = "Specifies whether this is for an AWS CloudFront distribution or for a regional application."
  value       = data.aws_wafv2_regex_pattern_set.this.scope
}

output "arn" {
  description = "ARN of the entity."
  value       = data.aws_wafv2_regex_pattern_set.this.arn
}

output "description" {
  description = "Description of the set that helps with identification."
  value       = data.aws_wafv2_regex_pattern_set.this.description
}

output "id" {
  description = "Unique identifier for the set."
  value       = data.aws_wafv2_regex_pattern_set.this.id
}

output "regular_expression" {
  description = "One or more blocks of regular expression patterns that AWS WAF is searching for."
  value       = data.aws_wafv2_regex_pattern_set.this.regular_expression
}