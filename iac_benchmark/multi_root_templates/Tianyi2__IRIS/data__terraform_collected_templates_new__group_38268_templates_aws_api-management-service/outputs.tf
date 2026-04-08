####### API Gateway Outputs ######
output "api_id" {
  value       = module.api_gateway.api_id
  description = "The ID of the REST API Gateway"
}

output "api_url" {
  value       = module.api_gateway.api_url
  description = "The URL of the REST API Gateway"
}

output "api_stage_name" {
  value       = module.api_gateway.api_stage_name
  description = "The names of the deployed stages"
}

output "api_stage_invoke_url" {
  value       = module.api_gateway.api_stage_invoke_url
  description = "The invoke URL of the deployed stage"
}

output "api_key_id" {
  value       = module.api_gateway.api_key_id
  description = "The ID of the API key"
}

output "api_key_value" {
  value       = module.api_gateway.api_key_value
  description = "The value of the API key"
  sensitive   = true
}

output "usage_plan_id" {
  value       = module.api_gateway.usage_plan_id
  description = "The ID of the API Gateway usage plan"
}

output "cloudwatch_log_group_name" {
  value       = module.api_gateway.cloudwatch_log_group_name
  description = "The names of the CloudWatch Log Groups for each stage."
}

output "api_gateway_role_arn" {
  description = "The ARN of the API Gateway role"
  value       = module.api_gateway.api_gateway_role_arn
}

####### WAF Outputs ######
output "web_acl_arn" {
  value       = module.waf.web_acl_arn
  description = "The ARN of the WebACL."
}

output "web_acl_id" {
  value       = module.waf.web_acl_id
  description = "The ID of the WebACL."
}

output "web_acl_capacity" {
  value       = module.waf.web_acl_capacity
  description = "The capacity of the WebACL."
}

output "waf_association_ids" {
  value       = module.waf.waf_association_ids
  description = "The IDs of the WAF associations."
}

output "cloudwatch_log_group_arn" {
  value       = module.waf.cloudwatch_log_group_arn
  description = "The ARN of the CloudWatch Log Group."
}

output "waf_logging_config_log_destination_configs" {
  value       = module.waf.waf_logging_config_log_destination_configs
  description = "The log destination configurations of the WAF logging configuration."
}

output "cloudwatch_log_resource_policy_id" {
  value       = module.waf.cloudwatch_log_resource_policy_id
  description = "The ID of the CloudWatch log resource policy."
}

####### CloudFront Distribution Outputs ######
output "cloudfront_distribution_id" {
  value       = module.cloudfront_distribution.cloudfront_distribution_id
  description = "The ID of the CloudFront distribution."
}

output "cloudfront_distribution_url" {
  value       = module.cloudfront_distribution.cloudfront_distribution_url
  description = "The domain name corresponding to the CloudFront distribution."
}

output "s3_bucket_id" {
  value       = module.cloudfront_distribution.s3_bucket_id
  description = "The ID of the S3 bucket for logs."
}

output "s3_bucket_arn" {
  value       = module.cloudfront_distribution.s3_bucket_arn
  description = "The ARN of the S3 bucket for logs."
}

output "cloudfront_origin_access_identity_id" {
  value       = module.cloudfront_distribution.cloudfront_origin_access_identity_id
  description = "The ID of the CloudFront Origin Access Identity."
}

output "cloudfront_origin_access_identity_iam_arn" {
  value       = module.cloudfront_distribution.cloudfront_origin_access_identity_iam_arn
  description = "The IAM ARN of the CloudFront Origin Access Identity."
}
