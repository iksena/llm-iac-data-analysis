variable "name" {
  description = "Name of the WAFv2 Web ACL. Exactly one of name or resource_arn must be specified."
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "resource_arn" {
  description = "ARN of the AWS resource associated with the Web ACL. This can be an ARN of an Application Load Balancer, Amazon API Gateway REST API, AWS AppSync GraphQL API, Amazon Cognito user pool, AWS App Runner service, AWS Verified Access instance, or AWS Amplify application. Exactly one of name or resource_arn must be specified."
  type        = string
  default     = null
}

variable "scope" {
  description = "Specifies whether this is for an AWS CloudFront distribution or for a regional application. Valid values are CLOUDFRONT or REGIONAL. To work with CloudFront, you must also specify the region us-east-1 (N. Virginia) on the AWS provider."
  type        = string

  validation {
    condition     = contains(["CLOUDFRONT", "REGIONAL"], var.scope)
    error_message = "data_aws_wafv2_web_acl, scope: valid values are CLOUDFRONT or REGIONAL."
  }
}