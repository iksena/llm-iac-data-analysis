variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "resource_arn" {
  description = "The Amazon Resource Name (ARN) of the resource to associate with the web ACL. This must be an ARN of an Application Load Balancer, an Amazon API Gateway stage (REST only, HTTP is unsupported), an Amazon Cognito User Pool, an Amazon AppSync GraphQL API, an Amazon App Runner service, or an Amazon Verified Access instance."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:[a-zA-Z0-9-]+:[a-z0-9-]*:[0-9]*:.+", var.resource_arn))
    error_message = "resource_aws_wafv2_web_acl_association, resource_arn must be a valid ARN format."
  }

  validation {
    condition     = can(regex("^arn:aws:(elasticloadbalancing|apigateway|cognito-idp|appsync|apprunner|ec2):", var.resource_arn))
    error_message = "resource_aws_wafv2_web_acl_association, resource_arn must be an ARN of an Application Load Balancer, Amazon API Gateway stage, Amazon Cognito User Pool, Amazon AppSync GraphQL API, Amazon App Runner service, or Amazon Verified Access instance."
  }
}

variable "web_acl_arn" {
  description = "The Amazon Resource Name (ARN) of the Web ACL that you want to associate with the resource."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:wafv2:[a-z0-9-]*:[0-9]*:(?:global|regional)/webacl/.+", var.web_acl_arn))
    error_message = "resource_aws_wafv2_web_acl_association, web_acl_arn must be a valid WAFv2 Web ACL ARN."
  }
}

variable "timeouts_create" {
  description = "Timeout for create operation"
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_create))
    error_message = "resource_aws_wafv2_web_acl_association, timeouts_create must be a valid timeout format (e.g., '5m', '30s', '1h')."
  }
}