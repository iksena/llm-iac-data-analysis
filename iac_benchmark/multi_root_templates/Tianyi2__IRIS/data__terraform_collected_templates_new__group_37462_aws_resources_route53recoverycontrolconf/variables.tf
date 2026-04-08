variable "name" {
  description = "Unique name describing the cluster"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_route53recoverycontrolconfig_cluster, name cannot be empty."
  }
}