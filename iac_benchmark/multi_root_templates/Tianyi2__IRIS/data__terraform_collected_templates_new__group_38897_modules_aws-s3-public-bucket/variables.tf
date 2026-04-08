variable "domain_name" {
  description = "Domain name to host the CDN on"
  type        = string
}

variable "certificate_arn" {
  description = "ACM Certificate ARN"
  type        = string
}

variable "zone_id" {
  description = "Route53 Zone ID of DNS Zone where the custom domain is registered"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the resources"
  type        = map(string)
  default     = {}
}

variable "cors_allowed_origins" {
  description = "List of allowed origins to the bucket in additions to the domain name, which is set by default."
  type        = list(string)
  default     = []
}

locals {
  tags_all = merge(var.tags, {
    Module = "aws-s3-public-bucket"
  })
}
