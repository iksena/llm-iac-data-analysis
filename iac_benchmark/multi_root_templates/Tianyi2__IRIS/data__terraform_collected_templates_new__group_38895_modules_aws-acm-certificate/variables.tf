variable "domain" {
  description = "Domain name to acquire certificate for"
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

locals {
  tags_all = merge(var.tags, {
    Module = "aws-acm-certificate"
  })
}
