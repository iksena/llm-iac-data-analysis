variable "vpc_origin_endpoint_config" {
  description = "The VPC origin endpoint configuration"
  type = object({
    arn                    = string
    http_port              = number
    https_port             = number
    name                   = string
    origin_protocol_policy = string
    origin_ssl_protocols = object({
      items    = list(string)
      quantity = number
    })
  })

  validation {
    condition     = can(regex("^arn:", var.vpc_origin_endpoint_config.arn))
    error_message = "resource_aws_cloudfront_vpc_origin, vpc_origin_endpoint_config.arn must be a valid ARN starting with 'arn:'."
  }

  validation {
    condition     = var.vpc_origin_endpoint_config.http_port >= 1 && var.vpc_origin_endpoint_config.http_port <= 65535
    error_message = "resource_aws_cloudfront_vpc_origin, vpc_origin_endpoint_config.http_port must be between 1 and 65535."
  }

  validation {
    condition     = var.vpc_origin_endpoint_config.https_port >= 1 && var.vpc_origin_endpoint_config.https_port <= 65535
    error_message = "resource_aws_cloudfront_vpc_origin, vpc_origin_endpoint_config.https_port must be between 1 and 65535."
  }

  validation {
    condition     = length(var.vpc_origin_endpoint_config.name) > 0
    error_message = "resource_aws_cloudfront_vpc_origin, vpc_origin_endpoint_config.name must not be empty."
  }

  validation {
    condition = contains([
      "http-only",
      "https-only",
      "match-viewer"
    ], var.vpc_origin_endpoint_config.origin_protocol_policy)
    error_message = "resource_aws_cloudfront_vpc_origin, vpc_origin_endpoint_config.origin_protocol_policy must be one of: http-only, https-only, match-viewer."
  }

  validation {
    condition     = var.vpc_origin_endpoint_config.origin_ssl_protocols.quantity >= 0
    error_message = "resource_aws_cloudfront_vpc_origin, vpc_origin_endpoint_config.origin_ssl_protocols.quantity must be non-negative."
  }

  validation {
    condition = alltrue([
      for protocol in var.vpc_origin_endpoint_config.origin_ssl_protocols.items : contains([
        "SSLv3",
        "TLSv1",
        "TLSv1.1",
        "TLSv1.2"
      ], protocol)
    ])
    error_message = "resource_aws_cloudfront_vpc_origin, vpc_origin_endpoint_config.origin_ssl_protocols.items must contain valid SSL/TLS protocol versions: SSLv3, TLSv1, TLSv1.1, TLSv1.2."
  }

  validation {
    condition     = var.vpc_origin_endpoint_config.origin_ssl_protocols.quantity == length(var.vpc_origin_endpoint_config.origin_ssl_protocols.items)
    error_message = "resource_aws_cloudfront_vpc_origin, vpc_origin_endpoint_config.origin_ssl_protocols.quantity must match the number of items in the list."
  }
}

variable "tags" {
  description = "Key-value tags for the CloudFront VPC origin"
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for tag_key in keys(var.tags) : length(tag_key) <= 128
    ])
    error_message = "resource_aws_cloudfront_vpc_origin, tags keys must be 128 characters or less."
  }

  validation {
    condition = alltrue([
      for tag_value in values(var.tags) : length(tag_value) <= 256
    ])
    error_message = "resource_aws_cloudfront_vpc_origin, tags values must be 256 characters or less."
  }
}