variable "name" {
  description = "Unique name for the CIDR collection"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_route53_cidr_collection, name must not be empty."
  }
}